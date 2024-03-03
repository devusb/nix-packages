{ ... }:
let
  modulesPerFile = {
    iterm2 = ./iterm2.nix;
  };

  default = { ... }: {
    imports = builtins.attrValues modulesPerFile;
  };
in
modulesPerFile // { inherit default; }
