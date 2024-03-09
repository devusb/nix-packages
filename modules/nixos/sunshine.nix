{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption mdDoc mkIf types generators;
  cfg = config.services.sunshine;
  appsFile = pkgs.writeText "apps.json" (generators.toJSON { } cfg.applications);
  configFile = pkgs.writeText "sunshine.conf" (generators.toKeyValue { } (cfg.settings // { file_apps = appsFile; }));
in
{
  options = {
    services.sunshine = with types; {
      enable = mkEnableOption (mdDoc "Sunshine");
      package = mkPackageOption pkgs "sunshine" { };
      settings = mkOption {
        default = { };
        type = submodule (settings: {
          freeformType = attrsOf str;
        });
      };
      applications = mkOption {
        default = { };
        type = submodule {
          options = {
            env = mkOption {
              default = { };
              type = attrsOf str;
            };
            apps = mkOption {
              default = [ ];
              type = listOf attrs;
            };
          };
        };
      };
    };
  };

  config = mkIf config.services.sunshine.enable {
    environment.systemPackages = [
      cfg.package
    ];

    boot.kernelModules = [ "uinput" ];

    services.udev.extraRules = ''
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    '';

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${cfg.package}/bin/sunshine";
    };

    systemd.user.services.sunshine = {
      description = "Self-hosted game stream host for Moonlight";
      wantedBy = [ "graphical-session.target" ];
      startLimitIntervalSec = 500;
      startLimitBurst = 5;
      partOf = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${config.security.wrapperDir}/sunshine ${configFile}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
