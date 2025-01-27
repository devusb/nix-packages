{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    types
    getExe
    ;
  inherit (utils) escapeSystemdExecArgs;
  cfg = config.services.hoarder-miniflux-webhook;
  settingsFormat = pkgs.formats.keyValue { };
  settingsFile = settingsFormat.generate ".env" cfg.settings;
in
{
  options.services.hoarder-miniflux-webhook = with types; {
    enable = mkEnableOption "Miniflux Webhook for Hoarder";
    package = mkPackageOption pkgs "hoarder-miniflux-webhook" { };
    environmentFile = mkOption {
      type = nullOr path;
      default = null;
    };
    settings = mkOption {
      default = { };
      type = submodule (settings: {
        freeformType = settingsFormat.type;
      });
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hoarder-miniflux-webhook = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Miniflux Webhook for Hoarder";
      serviceConfig = {
        EnvironmentFile = [
          settingsFile
          cfg.environmentFile
        ];
        DynamicUser = true;
        ExecStart = escapeSystemdExecArgs ([
          "${getExe cfg.package}"
        ]);

        Restart = "on-failure";
        RestartSec = "5s";

        ProtectSystem = "strict";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictNamespaces = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "yes";
        LockPersonality = "yes";
      };
    };
  };

}
