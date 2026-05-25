{ inputs, self, ... }:
{
  nixpkgs.overlays = [
    self.overlays.default
    (_: prev: { deckbd = inputs.deckbd.packages.${prev.stdenv.hostPlatform.system}.default; })
  ];
}
