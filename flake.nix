{
  description = "NixOS systems";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    ragenix.url = "github:yaxitech/ragenix";

  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      imports = [ ./lib/mksystem.nix ];

      perSystem =
        {
          pkgs,
          inputs',
          ...
        }:
        {

          devShells.default = pkgs.mkShell {
            name = "nixos-config-shell";
            meta.description = "Shell environment for modifying this Nix configuration";
            packages = with pkgs; [
              nixd
              nil
              inputs'.ragenix.packages.default
            ];
          };

        };

      flake = {
        nixosConfigurations = {
          ema = self.mkSystem.nixOS "ema" { withHomeManager = true; };
          pi = self.mkSystem.nixOS "pi" { };
        };

        darwinConfigurations.zion = self.mkSystem.macOS "zion" { withHomeManager = true; };

        checks.aarch64-linux = {

          ema = self.nixosConfigurations.ema.config.system.build.toplevel;

          pi = self.nixosConfigurations.pi.config.system.build.toplevel;
        };
      };
    };
}
