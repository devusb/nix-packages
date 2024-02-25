{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption types mkIf getExe getExe';
  cfg = config.services.quakejs;
in
{
  options.services.quakejs = with types; {
    package = mkPackageOption pkgs "quakejs" { };
    user = mkOption {
      type = str;
      default = "quakejs";
      description = lib.mdDoc "User account under which quakejs runs";
    };
    group = mkOption {
      type = str;
      default = "nogroup";
      description = lib.mdDoc "Group under which quakejs runs";
    };
    client = mkOption {
      default = { };
      type = submodule {
        options = {
          enable = mkEnableOption (mdDoc "quakejs web client");
          settings = mkOption {
            default = { };
            type = submodule (settings: {
              freeformType = attrsOf str;
              options.content = mkOption {
                type = str;
                default = "content.quakejs.com";
                description = "URL for Quake content";
              };
              options.port = mkOption {
                type = port;
                default = 8080;
                description = "Port for quakejs client";
              };
            });
          };
        };
      };
    };
    server = mkOption {
      default = { };
      type = submodule {
        options = {
          enable = mkEnableOption (mdDoc "quakejs dedicated server");
          settings = mkOption {
            default = { };
            type = submodule (settings: {
              options.hostname = mkOption {
                type = str;
                default = "quakejs";
                description = "quakejs server hostname";
              };
              options.port = mkOption {
                type = port;
                default = 27960;
                description = "Port for quakejs server";
              };
              options.password = mkOption {
                type = str;
                default = "quakejs";
                description = "rcon password for quakejs server";
              };
              options.dedicatedMode = mkOption {
                type = int;
                default = 1;
                description = "dedicated server mode";
              };
            });
          };
          dataDir = mkOption {
            type = str;
            default = "/var/lib/quakejs";
            description = "The directory where quakejs stores its files";
          };
          extraConfig = mkOption {
            type = lines;
            default = "";
            description = (mdDoc "Extra configuration options");
          };
        };
      };
    };
  };

  config =
    let
      clientConfigFile = pkgs.writeTextFile {
        name = "web.json";
        text = builtins.toJSON cfg.client.settings;
      };
      serverConfigFile = pkgs.writeTextFile {
        name = "q3ds.cfg";
        text = '' 
          set sv_hostname "${cfg.server.settings.hostname}"
          set dedicated ${builtins.toString cfg.server.settings.dedicatedMode}
          set rconpassword "${cfg.server.settings.password}"

        '' + cfg.server.extraConfig;
      };
      serverConfigFilePath = "${cfg.server.dataDir}/base/baseq3/${serverConfigFile.name}";
    in
    mkIf (cfg.server.enable || cfg.client.enable) {
      users.users = mkIf (cfg.user == "quakejs") {
        quakejs = { group = cfg.group; isSystemUser = true; };
      };

      systemd.services.quakejs-client = mkIf (cfg.client.enable == true) {
        description = "quakejs client";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${getExe' cfg.package "quakejs"} --config ${clientConfigFile}";
          Restart = "on-failure";
        };
      };

      systemd.tmpfiles.settings."quakejs-baseq3"."${cfg.server.dataDir}/base/baseq3".d = mkIf (cfg.server.enable == true) {
        user = cfg.user;
        group = cfg.group;
      };
      systemd.services.quakejs-server = mkIf (cfg.server.enable == true) {
        description = "quakejs server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.server.dataDir;
          BindReadOnlyPaths = [ "${serverConfigFile}:${serverConfigFilePath}" ];

          ExecStart = "${getExe' cfg.package "ioq3ded"} +set net_port ${builtins.toString cfg.server.settings.port} +exec ${serverConfigFile.name}";
          Restart = "on-failure";
        };
      };
    };
}
