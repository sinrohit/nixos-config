{
  description = "NixOS systems";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
    };

    addn-hosts = {
      url = "github:sinrohit/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixci.url = "github:sinrohit/nixci/refactor";

    st = {
      url = "github:siduck/st";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        ./lib
        ./modules/flake
      ];
    };
}
