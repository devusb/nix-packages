let
  modulesPerFile = {
    overlay = ./overlay.nix;
  };

  default = { ... }: {
    imports = builtins.attrValues modulesPerFile;
  };
in
modulesPerFile // { inherit default; }
