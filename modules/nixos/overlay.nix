{ inputs, ... }:
{
  # ensure packages from this flake are overlayed onto the system nixpkgs
  nixpkgs.overlays = [
    (_: prev: import ../../pkgs { pkgs = prev; })
    (_: prev: { deckbd = inputs.deckbd.packages.${prev.stdenv.hostPlatform.system}.default; })
  ];

}
