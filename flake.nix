{
  description = "devusb packages and modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs.lib) genAttrs;
      forAllSystems = genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      packages = forAllSystems (system:
        import ./pkgs { pkgs = import nixpkgs { inherit system; }; }
      );

      overlays = {
        default = final: prev: import ./pkgs { pkgs = prev; };
      };

      nixosModules = import ./modules;

    };
}
