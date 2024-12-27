{
  config,
  lib,
  pkgs,
  ...
}:

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

        options.port = lib.mkOption {
          type = lib.types.port;
          default = 8089;
          description = ''
            Which port this service should listen on.
          '';
        };
      });
    };
    devices = mkOption {
      type = types.listOf (
        types.submodule (settings: {
          freeformType = attrsOf str;
        })
      );
    };
  };

  config = mkIf cfg.enable {
    systemd.services.wolweb = {
      description = "wolweb";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${getExe cfg.package} -c ${pkgs.writeText "config.json" (builtins.toJSON cfg.settings)} -d ${
          pkgs.writeText "devices.json" (builtins.toJSON { devices = cfg.devices; })
        }";
        DynamicUser = true;
      };
    };
  };
}
