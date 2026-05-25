{
  description = "devusb packages and modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    deckbd = {
      url = "github:Ninlives/deckbd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          self',
          pkgs,
          lib,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
          };

          treefmt = {
            programs.nixfmt.enable = true;
            programs.nixfmt.package = pkgs.nixfmt-rfc-style;
            programs.yamlfmt.enable = true;
            programs.mdformat.enable = true;
            settings.excludes = [
              ".editorconfig"
              ".gitignore"
              "flake.lock"
              "*.h"
              "*.json"
            ];
          };

          legacyPackages = pkgs;
          packages = lib.getAttrs (builtins.attrNames (import ./overlay.nix { } { })) pkgs;

          checks =
            let
              blacklistPackages = {
                "aarch64-darwin" = [
                  "quakejs"
                  "igb"
                  "starship-sf64"
                  "Starship"
                  "dreamm"
                  "extest"
                  "battleship"
                ];
                "x86_64-linux" = [
                  "message-bridge"
                ];
                "aarch64-linux" = [
                  "message-bridge"
                ];
              };
              packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (
                lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages.${system})) self'.packages
              );
              nixosTests = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux (
                lib.mapAttrs' (
                  n: testFn:
                  lib.nameValuePair "nixos-${n}" (testFn {
                    inherit pkgs;
                    self = self;
                  })
                ) (import ./modules/nixos { inherit inputs self; }).tests
              );
            in
            packages // nixosTests;
        };

      flake = {
        overlays = {
          default = import ./overlay.nix;
        };

        nixosModules = import ./modules/nixos { inherit inputs self; };
        darwinModules = import ./modules/darwin { inherit inputs self; };
        homeManagerModules = import ./modules/home-manager { inherit inputs; };
      };

    };
}
