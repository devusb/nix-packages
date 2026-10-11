{ inputs, self, ... }:
{
  lib,
  specialArgs,
  ...
}:
{
  nixpkgs.overlays = lib.mkIf (!(specialArgs.osConfig.home-manager.useGlobalPkgs or false)) [
    self.overlays.default
    (_: prev: { collie = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}.collie; })
  ];
}
