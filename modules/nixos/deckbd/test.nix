# Unlocks a LUKS root with controller buttons, the way the Steam Deck does at
# boot. Follows nixpkgs' systemd-initrd-luks-password test, except the
# passphrase is typed by deckbd instead of the console.
{ pkgs, self }:
let
  controller = import ./fake-controller.nix { inherit pkgs; };
  # What the fake controller types: d-pad up, left bumper, right trigger.
  passphrase = "19";
in
pkgs.testers.nixosTest {
  name = "deckbd";
  nodes.machine =
    { lib, ... }:
    {
      imports = [
        self.nixosModules.overlay
        self.nixosModules.deckbd
      ];

      virtualisation = {
        emptyDiskImages = [ 512 ];
        useBootLoader = true;
        mountHostNixStore = true;
        useEFIBoot = true;
      };
      boot.loader.systemd-boot.enable = true;

      environment.systemPackages = [ pkgs.cryptsetup ];

      boot.initrd.systemd.enable = true;
      boot.initrd.deckbd.enable = true;

      boot.initrd.systemd.storePaths = controller.storePaths;
      boot.initrd.systemd.services.deckbd-test = {
        description = "Type the LUKS passphrase with a fake Steam Deck controller";
        wantedBy = [ "initrd.target" ];
        after = [ "systemd-modules-load.service" ];
        before = [ "initrd-switch-root.target" ];
        conflicts = [ "initrd-switch-root.target" ];
        unitConfig.DefaultDependencies = false;
        serviceConfig = {
          Type = "oneshot";
          ExecStart = controller.command;
          StandardOutput = "journal+console";
          StandardError = "journal+console";
        };
      };

      specialisation.boot-luks.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          cryptroot.device = "/dev/vdb";
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
      };
    };

  testScript =
    { nodes, ... }:
    let
      bootLuks = nodes.machine.specialisation.boot-luks.configuration.system.build.toplevel;
    in
    ''
      machine.wait_for_unit("multi-user.target")

      machine.succeed(
          "echo -n ${passphrase} | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -"
      )
      machine.succeed(
          "echo -n ${passphrase} | cryptsetup luksOpen -q /dev/vdb cryptroot"
      )
      machine.succeed("mkfs.ext4 /dev/mapper/cryptroot")

      machine.succeed("${bootLuks}/bin/switch-to-configuration boot")
      machine.succeed("sync")
      machine.crash()

      # No send_console here: deckbd types the passphrase from button presses.
      machine.start()
      machine.wait_for_unit("multi-user.target")

      assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")
    '';
}
