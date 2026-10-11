{ inputs, self, ... }:
{
  nixpkgs.overlays = [
    self.overlays.default
    (_: prev: { deckbd = inputs.deckbd.packages.${prev.stdenv.hostPlatform.system}.default; })
    (_: prev: {
      inherit (inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}) collie agent-deck;
    })
  ];
}
