{ pkgs, ... }:
let
  inherit (pkgs) callPackage linuxPackages kdePackages;
in
{
  go-simple-upload-server = callPackage ./go-simple-upload-server { };
  wolweb = callPackage ./wolweb { };
  jellyplex-watched = callPackage ./jellyplex-watched { };
  igb = linuxPackages.callPackage ./igb { };
  jellystat = callPackage ./jellystat { };
  supermodel = callPackage ./supermodel { };
  extest = callPackage ./extest { };
  go-plex-client = callPackage ./go-plex-client { };
  kde-rounded-corners = kdePackages.callPackage ./kde-rounded-corners { };
  pgdiff = callPackage ./pgdiff { };
  vkv = callPackage ./vkv { };
  sunshine-unstable = callPackage ./sunshine { };
  quakejs = callPackage ./quakejs { };

}
