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
  starship-sf64 = callPackage ./starship { stdenv = pkgs.clangStdenv; };
  Starship = starship-sf64;
  dreamm = callPackage ./dreamm { };
  hoarder-miniflux-webhook = callPackage ./hoarder-miniflux-webhook { };
  md2conf = callPackage ./md2conf { };
  fastmcp = callPackage ./fastmcp { };
  types-cachetools = callPackage ./types-cachetools { };
  mcp-atlassian = callPackage ./mcp-atlassian {
    inherit fastmcp types-cachetools;
    markdown-to-confluence = md2conf;
  };
  xmltv = callPackage ./xmltv { };
  dlt = callPackage ./dlt { };

}
