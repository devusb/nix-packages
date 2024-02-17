{ pkgs, ... }: {
  node-red = pkgs.callPackage ./node-red { };
  go-simple-upload-server = pkgs.callPackage ./go-simple-upload-server { };
  wolweb = pkgs.callPackage ./wolweb { };
  jellyplex-watched = pkgs.callPackage ./jellyplex-watched { };
  igb = pkgs.linuxPackages.callPackage ./igb { };
  jellystat = pkgs.callPackage ./jellystat { };
  supermodel = pkgs.callPackage ./supermodel { };

}
