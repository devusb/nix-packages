let 
  modulesPerFile = {
    overlay = ./overlay.nix;
    go-simple-upload-server = ./go-simple-upload-server.nix;
  };

  default = { ... }: {
    imports = builtins.attrValues modulesPerFile;
  };
in
  modulesPerFile // { inherit default; }
