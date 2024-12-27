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
  cfg = config.services.filebrowser;
  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "settings.json" cfg.settings;
in
{
  options.services.filebrowser = with types; {
    enable = mkEnableOption "Web File Browser";
    package = mkPackageOption pkgs "filebrowser" { };
    dataDir = mkOption {
      type = path;
      default = "/var/lib/filebrowser";
    };
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
    users.users.filebrowser = {
      isSystemUser = true;
      home = cfg.dataDir;
      description = "filebrowser system user";
      group = config.users.groups.filebrowser.name;
      createHome = true;
    };
    users.groups.filebrowser = {
      name = "filebrowser";
    };

    systemd.tmpfiles.settings."filebrowser-files"."${cfg.dataDir}/files".d = {
      user = config.users.users.filebrowser.name;
      group = config.users.groups.filebrowser.name;
    };
    services.filebrowser.settings.root = "${cfg.dataDir}/files";

    systemd.services.filebrowser = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Web File Browser";
      serviceConfig = {
        EnvironmentFile = [ cfg.environmentFile ];
        WorkingDirectory = cfg.dataDir;
        User = config.users.users.filebrowser.name;
        ExecStart = escapeSystemdExecArgs ([
          "${getExe cfg.package}"
          "-c"
          "${settingsFile}"
        ]);

        Restart = "on-failure";
        RestartSec = "5s";

        ProtectSystem = "strict";
        ReadWritePaths = [
          "/run/filebrowser"
          cfg.dataDir
        ];
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
