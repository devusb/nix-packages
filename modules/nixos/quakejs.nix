{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption types mkIf getExe;
  cfg = config.services.quakejs;
in
{
  options.services.quakejs = with types; {
    enable = mkEnableOption (mdDoc "Web ioquake3 client");
    package = mkPackageOption pkgs "quakejs" { };
    settings = mkOption {
      type = types.attrsOf types.unspecified;
      default = {
        content = "content.quakejs.com";
      };
    };
  };

  config =
    let
      configFile = pkgs.writeTextFile {
        name = "web.json";
        text = builtins.toJSON cfg.settings;
      };
    in
    mkIf cfg.enable {
      systemd.services.quakejs = {
        description = "quakejs";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${getExe cfg.package} --config ${configFile}";
          DynamicUser = true;
        };
      };
    };
}
