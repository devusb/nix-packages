{ inputs, ... }:
let
  modulesPerFile = {
    overlay = ./overlay.nix { inherit inputs; };
  };

  default = { ... }: {
    imports = builtins.attrValues modulesPerFile;
  };
in
modulesPerFile // { inherit default; }
