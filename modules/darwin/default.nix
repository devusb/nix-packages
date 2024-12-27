{ inputs, ... }:
let
  modulesPerFile = {
    overlay = import ./overlay.nix { inherit inputs; };
  };

  default =
    { ... }:
    {
      imports = builtins.attrValues modulesPerFile;
    };
in
modulesPerFile // { inherit default; }
