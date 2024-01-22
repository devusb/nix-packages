{
  # ensure packages from this flake are overlayed onto the system nixpkgs
  nixpkgs.overlays = [ (final: prev: import ../pkgs { pkgs = prev; }) ];

}
