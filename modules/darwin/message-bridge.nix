{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    ;
  cfg = config.services.message-bridge;
in
{
  options.services.message-bridge = {
    enable = mkEnableOption "the message-bridge service.";

    package = mkPackageOption pkgs "message-bridge" { };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        Which port the service should listen on.
      '';
    };

    hostname = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        What hostname to associate with.
      '';
    };
  };

  config = mkIf cfg.enable {
    launchd.user.agents.message-bridge = {
      command = "${lib.getExe pkgs.message-bridge} serve --hostname ${cfg.hostname} --port ${builtins.toString cfg.port}";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Background";
      };
    };
  };
}
