{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption types mkIf getExe getExe';
  cfg = config.services.quakejs;
in
{
  options.services.quakejs = with types; {
    package = mkPackageOption pkgs "quakejs" { };
    user = mkOption {
      type = types.str;
      default = "quakejs";
      description = lib.mdDoc "User account under which quakejs runs";
    };
    group = mkOption {
      type = types.str;
      default = "nogroup";
      description = lib.mdDoc "Group under which quakejs runs";
    };
    client = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption (mdDoc "quakejs web client");
          settings = mkOption {
            type = types.attrsOf types.unspecified;
            default = {
              content = "content.quakejs.com";
            };
          };
        };
      };
      default = { };
    };
    server = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption (mdDoc "quakejs dedicated server");
          dataDir = mkOption {
            type = types.str;
            default = "/var/lib/quakejs";
            description = "The directory where quakejs stores its files";
          };
          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = (mdDoc "Extra configuration options");
          };
        };
      };
      default = { };
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
        text = cfg.server.extraConfig;
      };
      serverConfigFilePath = "${cfg.server.dataDir}/base/baseq3/${serverConfigFile.name}";
      serverInit = pkgs.writeShellScriptBin "server-init.sh" ''
        cp ${serverConfigFile} ${serverConfigFilePath} 
        chown ${cfg.user}:${cfg.group} ${serverConfigFilePath} 
      '';
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

      systemd.tmpfiles.settings."quakejs-data"."${cfg.server.dataDir}/base/baseq3".d = mkIf (cfg.server.enable == true) {
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
          ReadOnlyPaths = serverConfigFilePath;

          ExecStartPre = "${getExe serverInit}";
          ExecStart = "${getExe' cfg.package "ioq3ded"} +exec ${serverConfigFile.name}";
          Restart = "on-failure";
        };
      };
    };
}
