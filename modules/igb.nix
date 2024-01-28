{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.igb;
in
{
  options.hardware.igb = with types; {
    enable = mkEnableOption (mdDoc "Linux Base Driver for Intel® Gigabit Ethernet Network Connections");
  };

  config =
    mkIf cfg.enable {
      boot = {
        extraModulePackages = [
          (config.boot.kernelPackages.callPackage ../pkgs/igb { })
        ];
      };
    };
}
