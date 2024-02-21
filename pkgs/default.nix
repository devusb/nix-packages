{ pkgs, ... }: {
  go-simple-upload-server = pkgs.callPackage ./go-simple-upload-server { };
  wolweb = pkgs.callPackage ./wolweb { };
  jellyplex-watched = pkgs.callPackage ./jellyplex-watched { };
  igb = pkgs.linuxPackages.callPackage ./igb { };
  jellystat = pkgs.callPackage ./jellystat { };
  supermodel = pkgs.callPackage ./supermodel { };
  extest = pkgs.callPackage ./extest { };
  go-plex-client = pkgs.callPackage ./go-plex-client { };
  kde-rounded-corners = pkgs.qt6Packages.callPackage ./kde-rounded-corners { kwin = pkgs.kde2nix.kwin; kcmutils = pkgs.kde2nix.kcmutils; };
  pgdiff = pkgs.callPackage ./pgdiff { };
  vkv = pkgs.callPackage ./vkv { };
  sunshine-unstable = pkgs.callPackage ./sunshine { };

}
