{
  lib,
  inputs,
  self,
  ...
}:
let
  specialArgs = { inherit self inputs; };

  common =
    { pkgs, config, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        users."rohit" = import ../home;
        sharedModules = [
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
          }
        ]
        ++ (if pkgs.stdenv.isDarwin then [ ../home/darwin.nix ] else [ ../home/linux.nix ]);
      };
    };

in
{
  options.homeModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
    description = "Home-manager modules for different platforms";
  };

  config.homeModules = {

    # Define the home-manager module that will be used in MacOS systems
    darwinHomeManagerModule = {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        common
      ];
    };

    # Define the home-manager module that will be used in NixOS systems
    nixosHomeManagerModule = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        common
      ];
    };
  };
}
