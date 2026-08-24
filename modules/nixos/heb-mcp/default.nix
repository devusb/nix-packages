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
    mkDefault
    types
    getExe
    optional
    ;
  inherit (utils) escapeSystemdExecArgs;
  cfg = config.services.heb-mcp;
  settingsFormat = pkgs.formats.keyValue { };
  settingsFile = settingsFormat.generate "heb-mcp.env" cfg.settings;
in
{
  options.services.heb-mcp = with types; {
    enable = mkEnableOption "H-E-B MCP server";
    package = mkPackageOption pkgs "heb-mcp" { };

    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        Path to a file with additional environment variables, merged over
        {option}`services.heb-mcp.settings`. Use this for secrets such as
        `HEB_SESSION_ENCRYPTION_KEY`.
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Environment variables passed to the server. See the upstream README
        for the full set.
      '';
      example = {
        PORT = 3001;
        MCP_SERVER_URL = "https://heb-mcp.example.com";
        CLERK_JWKS_URL = "https://auth.example.com/application/o/heb-mcp/jwks/";
        CLERK_FRONTEND_URL = "https://auth.example.com/application/o/heb-mcp/";
      };
      type = submodule {
        freeformType = settingsFormat.type;
        options = {
          PORT = mkOption {
            type = port;
            description = "Port the server listens on.";
          };
          MCP_SERVER_URL = mkOption {
            type = str;
            description = "Externally reachable base URL, used for OAuth metadata.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.heb-mcp.settings = {
      MCP_MODE = mkDefault "remote";
      MCP_LISTEN = mkDefault "127.0.0.1";
      PORT = mkDefault 3000;
      HEB_SESSION_STORE_DIR = mkDefault "/var/lib/heb-mcp/sessions";
      MCP_OAUTH_CLIENTS_FILE = mkDefault "/var/lib/heb-mcp/oauth/clients.json";
      MCP_OAUTH_TOKENS_FILE = mkDefault "/var/lib/heb-mcp/oauth/tokens.json";
    };

    systemd.services.heb-mcp = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "H-E-B MCP server";
      serviceConfig = {
        EnvironmentFile = [ settingsFile ] ++ optional (cfg.environmentFile != null) cfg.environmentFile;
        DynamicUser = true;
        StateDirectory = "heb-mcp";
        ExecStart = escapeSystemdExecArgs [
          "${getExe cfg.package}"
        ];

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
        LockPersonality = "yes";

        CapabilityBoundingSet = "";
        AmbientCapabilities = "";
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictRealtime = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
