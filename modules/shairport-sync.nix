{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.shairport-sync;
in
{
  disabledModules = [ "services/networking/shairport-sync.nix" ];
  options = {
    services.shairport-sync = {
      enable = mkEnableOption (mdDoc "shairport-sync");
      package = mkPackageOption pkgs "shairport-sync" { };
      audioMethod = mkOption {
        type = types.str;
        default = "pw";
        description = "Audio method to use";
      };
    };
  };
  config = mkIf config.services.shairport-sync.enable {
    services.nqptp.enable = true;
    systemd.user.services.shairport-sync =
      {
        description = "shairport-sync";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/shairport-sync -o ${cfg.audioMethod} -a ${config.networking.hostName}";
        };
      };
  };
}
