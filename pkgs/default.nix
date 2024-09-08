{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
  linuxPackages = pkgs.linuxPackages_6_1;
in
{
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

}
