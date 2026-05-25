{ inputs, self, ... }:
let
  modulesPerFile = {
    overlay = import ./overlay.nix { inherit inputs self; };
    message-bridge = ./message-bridge.nix;
  };

  default =
    { ... }:
    {
      imports = builtins.attrValues modulesPerFile;
    };
in
modulesPerFile // { inherit default; }
