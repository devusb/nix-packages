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
    mdDoc
    ;
  cfg = config.programs.reversepuck;
in
{
  options = {
    programs.reversepuck = {
      enable = mkEnableOption (mdDoc "ReversePuck Steam Deck forwarder for OpenPuck");
      package = mkPackageOption pkgs "reversepuck" { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.udev.extraRules = ''
      # nRF ReversePuck dongle CDC link (Valve 28DE:1302) -> /dev/ttyACM*
      SUBSYSTEM=="tty", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="1302", TAG+="uaccess"
      # Steam Deck built-in controller (Valve 28DE:1205) for USB-level detach
      SUBSYSTEM=="usb", ATTR{idVendor}=="28de", ATTR{idProduct}=="1205", TAG+="uaccess"
    '';
  };
}
