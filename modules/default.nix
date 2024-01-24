let
  modulesPerFile = {
    overlay = ./overlay.nix;
    go-simple-upload-server = ./go-simple-upload-server.nix;
    wolweb = ./wolweb.nix;
    jellylex-watched = ./jellyplex-watched.nix;
  };

  default = { ... }: {
    imports = builtins.attrValues modulesPerFile;
  };
in
modulesPerFile // { inherit default; }
