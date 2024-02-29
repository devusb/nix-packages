{
  description = "devusb packages and modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hercules-ci-effects.url = "github:mlabs-haskell/hercules-ci-effects/push-cache-effect";
    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, hercules-ci-effects, attic, ... }:
    let
      ciSystems = [ "x86_64-linux" ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        hercules-ci-effects.push-cache-effect
        hercules-ci-effects.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: { kde2nix = inputs.kde2nix.packages.${system}; })
          ];
        };
        formatter = pkgs.nixpkgs-fmt;
        packages = import ./pkgs { inherit pkgs; };
      };

      herculesCI.ciSystems = ciSystems;
      push-cache-effect = {
        enable = true;
        attic-client-pkg = attic.packages.x86_64-linux.attic-client;
        caches.r2d2 = {
          type = "attic";
          secretName = "attic";
          packages = builtins.concatLists (builtins.map (attr: (builtins.attrValues self.packages."${attr}")) ciSystems);
        };
      };

      flake = {
        overlays = {
          default = final: prev: import ./pkgs { pkgs = prev; };
        };

        nixosModules = import ./modules/nixos;
        darwinModules = import ./modules/darwin;
        homeManagerModules = import ./modules/home-manager;
      };

    };
}
