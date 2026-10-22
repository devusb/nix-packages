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

    boot.initrd.systemd = {
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
