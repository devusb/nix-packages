{ inputs, self, ... }:
let
  modulesPerFile = {
    overlay = import ./overlay.nix { inherit inputs self; };
    iterm2 = ./iterm2.nix;
    herdr = ./herdr.nix;
    collie = ./collie.nix;
    agent-deck = ./agent-deck.nix;
  };

  default =
    { ... }:
    {
      imports = builtins.attrValues modulesPerFile;
    };
in
modulesPerFile // { inherit default; }
