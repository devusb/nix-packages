{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zz-sdjson;
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    types
    getExe'
    ;
in
{
  options.services.zz-sdjson = {
    enable = mkEnableOption "grabbing TV listings from Schedules Direct SD-JSON service";
    package = mkPackageOption pkgs "xmltv" { };
    configFile = mkOption {
      type = types.path;
      description = ''
        Path to config file for tv_grab_zz_sdjson
      '';
    };
    refreshTime = mkOption {
      type = types.str;
      default = "Sat 02:00:00";
      description = ''
        Refresh schedule for TV listings
      '';
    };
    days = mkOption {
      type = types.int;
      default = 10;
      description = ''
        Numbers of days to grab listings
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.zz-sdjson = {
      description = "zz-sdjson service user";
      isSystemUser = true;
      group = "zz-sdjson";
    };

    users.groups.zz-sdjson = { };

    systemd.services.zz-sdjson = {
      description = "Grabber for Schedules Direct TV listings";
      environment.HOME = "/var/lib/zz-sdjson";
      startAt = cfg.refreshTime;
      serviceConfig = {
        type = "oneshot";
        ExecStart = "${getExe' cfg.package "tv_grab_zz_sdjson"} --days ${builtins.toString cfg.days} --output /var/lib/zz-sdjson/guide.xml --config-file ${cfg.configFile}";
        User = "zz-sdjson";
        Group = "zz-sdjson";
        StateDirectory = "zz-sdjson";
        StateDirectoryMode = "0755";
        WorkingDirectory = "/var/lib/zz-sdjson";
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
      };
    };
  };
}
