{ pkgs, ... }:
let
  inherit (pkgs) callPackage lib;
  linuxPackages = pkgs.linuxPackages_6_1;
in
rec {
  go-simple-upload-server = callPackage ./go-simple-upload-server { };
  wolweb = callPackage ./wolweb { };
  jellyplex-watched = callPackage ./jellyplex-watched { };
  igb = linuxPackages.callPackage ./igb { };
  jellystat = callPackage ./jellystat { };
  extest = callPackage ./extest { };
  go-plex-client = callPackage ./go-plex-client { };
  pgdiff = callPackage ./pgdiff { };
  vkv = callPackage ./vkv { };
  quakejs = callPackage ./quakejs { };
  presenterm-export = callPackage ./presenterm-export { };
  podman-bootc = callPackage ./podman-bootc { };
  tv-sony = callPackage ./tv-sony { };
  simple-proxy = callPackage ./simple-proxy { };
  starship-sf64 = callPackage ./starship { stdenv = pkgs.clangStdenv; };
  Starship = starship-sf64;
  torch = callPackage ./torch {
    spdlog = pkgs.spdlog.overrideAttrs (old: {
      version = "1.12.0-unstable-2023-07-08";
      src = old.src.override {
        # matches vendored version of spdlog used by upstream
        rev = "7e635fca68d014934b4af8a1cf874f63989352b7";
        hash = "sha256-cxTaOuLXHRU8xMz9gluYz0a93O0ez2xOxbloyc1m1ns=";
      };
      postInstall = ''
        mkdir -p $out/share/doc/spdlog
        cp -rv ../example $out/share/doc/spdlog
      '';
      cmakeFlags = lib.lists.remove "-DSPDLOG_FMT_EXTERNAL=ON" old.cmakeFlags;
      doCheck = false;
    });
  };
  dreamm = callPackage ./dreamm { };

}
