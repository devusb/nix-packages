{ inputs, self, ... }:
{
  nixpkgs.overlays = [
    self.overlays.default
    (_: prev: { collie = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}.collie; })
  ];
}
