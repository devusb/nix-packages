{ pkgs, ... }: {
  node-red = pkgs.callPackage ./node-red { };
  go-simple-upload-server = pkgs.callPackage ./go-simple-upload-server { };
}
