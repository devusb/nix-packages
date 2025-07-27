{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
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
  podman-bootc = callPackage ./podman-bootc { };
  tv-sony = callPackage ./tv-sony { };
  simple-proxy = callPackage ./simple-proxy { };
  dreamm = callPackage ./dreamm { };
  hoarder-miniflux-webhook = callPackage ./hoarder-miniflux-webhook { };
  xmltv = callPackage ./xmltv { };

}
