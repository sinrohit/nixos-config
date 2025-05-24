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

      imports = [
        ./lib/mksystem.nix
        ./modules/flake/devShell.nix
        ./modules/flake/systems.nix
        ./modules/flake/checks.nix
        ./modules/flake/configurations.nix
      ];
    };
}
