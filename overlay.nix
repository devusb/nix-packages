final: prev: {
  go-simple-upload-server = final.callPackage ./pkgs/go-simple-upload-server { };
  wolweb = final.callPackage ./pkgs/wolweb { };
  jellyplex-watched = final.callPackage ./pkgs/jellyplex-watched { };
  igb = final.linuxPackages_6_1.callPackage ./pkgs/igb { };
  jellystat = final.callPackage ./pkgs/jellystat { };
  extest = final.callPackage ./pkgs/extest { };
  go-plex-client = final.callPackage ./pkgs/go-plex-client { };
  pgdiff = final.callPackage ./pkgs/pgdiff { };
  vkv = final.callPackage ./pkgs/vkv { };
  quakejs = final.callPackage ./pkgs/quakejs { };
  tv-sony = final.callPackage ./pkgs/tv-sony { };
  simple-proxy = final.callPackage ./pkgs/simple-proxy { };
  dreamm = final.callPackage ./pkgs/dreamm { };
  hoarder-miniflux-webhook = final.callPackage ./pkgs/hoarder-miniflux-webhook { };
  xmltv = final.callPackage ./pkgs/xmltv { };
  dlt = final.callPackage ./pkgs/dlt { };
  setec = final.callPackage ./pkgs/setec { };
  message-bridge = final.callPackage ./pkgs/message-bridge { };
  calibre-web-automated = final.callPackage ./pkgs/calibre-web-automated { };
  battleship = final.callPackage ./pkgs/battleship { };
  openjkdf2 = final.callPackage ./pkgs/openjkdf2 { };
  openjkdf2-gles = final.callPackage ./pkgs/openjkdf2/gles.nix { };
}
