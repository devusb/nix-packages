{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.calibre-web-automated;

  inherit (lib)
    concatStringsSep
    mkEnableOption
    mkIf
    mkOption
    optional
    optionals
    optionalString
    types
    ;
in
{
  options = {
    services.calibre-web-automated = {
      enable = mkEnableOption "Calibre-Web Automated";

      package = lib.mkPackageOption pkgs "calibre-web-automated" { };

      listen = {
        ip = mkOption {
          type = types.str;
          default = "::1";
          description = ''
            IP address that Calibre-Web Automated should listen on.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 8083;
          description = ''
            Listen port for Calibre-Web Automated.
          '';
        };
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/calibre-web-automated";
        description = ''
          Directory for Calibre-Web Automated state and configuration.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "calibre-web-automated";
        description = "User account under which Calibre-Web Automated runs.";
      };

      group = mkOption {
        type = types.str;
        default = "calibre-web-automated";
        description = "Group account under which Calibre-Web Automated runs.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the server.
        '';
      };

      options = {
        calibreLibrary = mkOption {
          type = types.nullOr types.path;
          default = "${cfg.dataDir}/library";
          defaultText = lib.literalExpression ''"''${cfg.dataDir}/library"'';
          description = ''
            Path to Calibre library.
          '';
        };

        ingestDir = mkOption {
          type = types.path;
          default = "${cfg.dataDir}/ingest";
          defaultText = lib.literalExpression ''"''${cfg.dataDir}/ingest"'';
          description = ''
            Path to the book ingest directory. Books placed here will be
            automatically imported into the Calibre library.
          '';
        };

        enableBookConversion = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Configure path to the Calibre's ebook-convert in the DB.
          '';
        };

        enableKepubify = mkEnableOption "kepub conversion support";

        enableBookUploading = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow books to be uploaded via Calibre-Web Automated UI.
          '';
        };

        reverseProxyAuth = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable authorization using auth proxy.
            '';
          };

          header = mkOption {
            type = types.str;
            default = "";
            description = ''
              Auth proxy header name.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.settings."10-calibre-web-automated" = {
      ${cfg.dataDir}.d = {
        inherit (cfg) user group;
        mode = "0700";
      };
      ${cfg.options.ingestDir}.d = {
        inherit (cfg) user group;
        mode = "0700";
      };
    };

    systemd.services.calibre-web-automated =
      let
        appDb = "${cfg.dataDir}/app.db";
        gdriveDb = "${cfg.dataDir}/gdrive.db";
        calibreWebCmd = "${cfg.package}/bin/calibre-web -p ${appDb} -g ${gdriveDb}";

        settings = concatStringsSep ", " (
          [
            "config_external_port = ${toString cfg.listen.port}"
            "config_uploading = ${if cfg.options.enableBookUploading then "1" else "0"}"
            "config_allow_reverse_proxy_header_login = ${
              if cfg.options.reverseProxyAuth.enable then "1" else "0"
            }"
            "config_reverse_proxy_login_header_name = '${cfg.options.reverseProxyAuth.header}'"
          ]
          ++ optional (
            cfg.options.calibreLibrary != null
          ) "config_calibre_dir = '${cfg.options.calibreLibrary}'"
          ++ optionals cfg.options.enableBookConversion [
            "config_converterpath = '${pkgs.calibre}/bin/ebook-convert'"
            "config_binariesdir = '${pkgs.calibre}/bin/'"
          ]
          ++ optional cfg.options.enableKepubify "config_kepubifypath = '${pkgs.kepubify}/bin/kepubify'"
        );
      in
      {
        description = "Calibre-Web Automated";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        path = [ pkgs.calibre ];
        environment.CACHE_DIR = "/var/cache/calibre-web-automated";
        environment.CALIBRE_DBPATH = "/config";
        environment.NETWORK_SHARE_MODE = "true";

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;

          ExecStartPre = pkgs.writeShellScript "calibre-web-automated-pre-start" (
            ''
              __RUN_MIGRATIONS_AND_EXIT=1 ${calibreWebCmd}

              ${pkgs.sqlite}/bin/sqlite3 ${appDb} "update settings set ${settings}"
            ''
            + optionalString (cfg.options.calibreLibrary != null) ''
              test -f "${cfg.options.calibreLibrary}/metadata.db" || { echo "Invalid Calibre library"; exit 1; }
            ''
          );

          ExecStart = "${calibreWebCmd} -i ${cfg.listen.ip}";
          Restart = "on-failure";

          BindPaths = [
            "${cfg.dataDir}:/config"
            "${cfg.options.ingestDir}:/cwa-book-ingest"
          ];
          CacheDirectory = "calibre-web-automated";
          CacheDirectoryMode = "0750";
        };
      };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

    users.users = mkIf (cfg.user == "calibre-web-automated") {
      calibre-web-automated = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = mkIf (cfg.group == "calibre-web-automated") {
      calibre-web-automated = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ devusb ];
}
