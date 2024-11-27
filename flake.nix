{
  inputs = {

    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    systems.url = "github:nix-systems/default";

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    ragenix.url = "github:yaxitech/ragenix";

    omnix.url = "github:juspay/omnix";

    # Devshell
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
      imports = [
        inputs.nixos-unified.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { pkgs, self', config, inputs', ... }: {

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
        };

        devShells.default = pkgs.mkShell {
          name = "nixos-config-shell";
          meta.description = "Shell environment for modifying this Nix configuration";
          packages = with pkgs; [
            just
            nixd
            inputs'.ragenix.packages.default
          ];
        };

        packages.default = self'.packages.activate; # Enables `nix run`

      };

      flake = {
        # Configurations for Linux (NixOS) machines
        nixosConfigurations = {
          enigma = self.nixos-unified.lib.mkLinuxSystem { home-manager = true; } {
            imports = [ ./machines/enigma/configuration.nix ];
            nixos-unified.sshTarget = "enigma";
          };

          pi = self.nixos-unified.lib.mkLinuxSystem { home-manager = false; } {
            imports = [ 
              ./machines/pi/configuration.nix
              inputs.ragenix.nixosModules.default
            ];
            nixos-unified.sshTarget = "pi";
          };

        };

        darwinConfigurations.rohitsingh-M4KLJ7DH4V = self.nixos-unified.lib.mkMacosSystem { home-manager = true; } {
          imports = [ ./machines/zion/configuration.nix ];
        };
      };
    };
}
