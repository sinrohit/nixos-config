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
  imports = [ ./home.nix ];

  config.flake.mkSystem.macOS =
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

        ../modules/darwin
        ../machines/${hostName}
      ]
      ++ lib.optional withHomeManager config.homeModules.darwinHomeManagerModule;
    };
}
