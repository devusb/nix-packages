{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.boot.initrd.deckbd;
  deckbd = getExe' cfg.package "deckbd";
in
{
  options = {
    boot.initrd.deckbd = {
      enable = mkEnableOption (mdDoc "deckbd to use Steam Deck controller for LUKS passphrase");
      package = mkPackageOption pkgs "deckbd" { };
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [
      "uinput"
      "evdev"
      "hid_steam"
    ];

    boot.initrd.preLVMCommands = mkIf (!config.boot.initrd.systemd.enable) ''
      try=10
      while true;do
        ${deckbd} query && break
        if test $try -le 0;then break; fi
        sleep 1
        echo "Waiting for controller to appear, $try retry remains..."
        try=$((try - 1))
      done
      echo "Initialise deckbd";
      ${deckbd} &
      DECKBD_PID=$!
    '';

    boot.initrd.postMountCommands = mkIf (!config.boot.initrd.systemd.enable) ''
      kill $DECKBD_PID
    '';

    boot.initrd.systemd = mkIf config.boot.initrd.systemd.enable {
      storePaths = [ deckbd ];

      services.deckbd = {
        description = "Steam Deck controller as a keyboard for LUKS passphrase entry";
        wantedBy = [ "initrd.target" ];
        before = [
          "shutdown.target"
          "initrd-switch-root.target"
        ];
        conflicts = [
          "shutdown.target"
          "initrd-switch-root.target"
        ];
        unitConfig = {
          DefaultDependencies = false;
          StartLimitIntervalSec = 0;
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = deckbd;
          Restart = "on-failure";
          RestartSec = 1;
        };
      };
    };
  };
}
