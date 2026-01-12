{
  inputs,
  self,
  lib,
  config,
  ...
}:
let
  common = import ./common.nix;

  specialArgs = { inherit self inputs; };
in
{
  # Import home.nix to make homeModules available
  imports = [ ./home.nix ];

  config.flake.mkSystem.nixOS =
    hostName:
    {
      withHomeManager ? false,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = [
        # Apply our overlays
        {
          nixpkgs.overlays = [ (import ../overlays { inherit inputs; }) ];
        }

        common

        # Allow unfree packages
        { nixpkgs.config.allowUnfree = true; }

        ../machines/${hostName}
      ]
      ++ lib.optional withHomeManager config.homeModules.nixosHomeManagerModule;
    };
}
