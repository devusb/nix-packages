{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wolweb;
in
{
  options.services.wolweb = with types; {
    enable = mkEnableOption (mdDoc "Web interface for sending Wake-on-lan");
    package = mkPackageOption pkgs "wolweb" { };
    settings = mkOption {
      type = types.submodule (settings: {
        freeformType = attrsOf str;
      });
    };
  };

  config =
    mkIf cfg.enable {
      systemd.services.wolweb = {
        description = "wolweb";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = cfg.settings;

        serviceConfig = {
          ExecStart = "${getExe cfg.package}";
          DynamicUser = true;
        };
      };
    };
}
