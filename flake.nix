{
  description = "devusb packages and modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    deckbd = {
      url = "github:Ninlives/deckbd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = { self', pkgs, lib, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
        };
        formatter = pkgs.nixpkgs-fmt;
        packages = import ./pkgs { inherit pkgs; };

        checks =
          let
            blacklistPackages = {
              "aarch64-darwin" = [
                "quakejs"
                "igb"
                "podman-bootc"
              ];
              "x86_64-linux" = [ ];
              "aarch64-linux" = [ ];
            };
            packages =
              lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages.${system})) self'.packages);
          in
          packages;
      };

      flake = {
        overlays = {
          default = final: prev: import ./pkgs { pkgs = prev; };
        };

        nixosModules = import ./modules/nixos { inherit inputs; };
        darwinModules = import ./modules/darwin { inherit inputs; };
        homeManagerModules = import ./modules/home-manager { inherit inputs; };
      };

    };
}
