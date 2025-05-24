{
  self,
  lib,
  inputs,
  ...
}:

let
  specialArgs = { inherit self inputs; };

  nixosModules = {
    home-manager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users."rohit" = import ../home;
        }
      ];
    };
  };
  # Common and useful setting across all platforms
  common =
    { lib, ... }:
    {
      nix = {
        settings = {
          # Use all CPU cores
          max-jobs = lib.mkDefault "auto";
          experimental-features = lib.mkDefault "nix-command flakes";
          substituters = [ "https://cache.clan.lol" ];
          trusted-public-keys = [ "cache.clan.lol-1:3KztgSAB5R1M+Dz7vzkBGzXdodizbgLXGXKXlcQLA28=" ];
        };
      };
    };

  homeModules = {
    common =
      { config, pkgs, ... }:
      {
        # Sensible default for `home.homeDirectory`
        home.homeDirectory = lib.mkDefault "/${
          if pkgs.stdenv.isDarwin then "Users" else "home"
        }/${config.home.username}";

        # For macOS, $PATH must contain these.
        home.sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
          "/etc/profiles/per-user/$USER/bin" # To access home-manager binaries
          "/nix/var/nix/profiles/system/sw/bin" # To access nix-darwin binaries
          "/usr/local/bin" # Some macOS GUI programs install here
        ];
      };
  };
  darwinModules = {
    home-manager = {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ homeModules.common ];
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users."rohit" = import ../home;
        }
      ];
    };
  };
in
{
  config.flake.mkSystem = {
    nixOS =
      hostName:
      {
        withHomeManager ? false,
      }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          # Apply our overlays. Overlays are keyed by system type so we have
          # to go through and apply our system type. We do this first so
          # the overlays are available globally.
          {
            nixpkgs.overlays = [ (import ../overlays { inherit inputs; }) ];
          }
          common

          # Allow unfree packages.
          { nixpkgs.config.allowUnfree = true; }

          ../machines/${hostName}
          ../modules/nixos
        ] ++ lib.optional withHomeManager nixosModules.home-manager;
      };

    macOS =
      hostName:
      {
        withHomeManager ? false,
      }:
      inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [
          # Apply our overlays. Overlays are keyed by system type so we have
          # to go through and apply our system type. We do this first so
          # the overlays are available globally.
          {
            nixpkgs.overlays = [ (import ../overlays { inherit inputs; }) ];
          }
          common

          # Allow unfree packages.
          { nixpkgs.config.allowUnfree = true; }

          ../machines/${hostName}
        ] ++ lib.optional withHomeManager darwinModules.home-manager;
      };
  };
}
