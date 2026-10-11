{ inputs, self, ... }:
{
  nixpkgs.overlays = [
    self.overlays.default
    (_: prev: {
      inherit (inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}) collie agent-deck;
    })
  ];
}
