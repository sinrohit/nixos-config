{
  inputs = {

    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    systems.url = "github:nix-systems/default";

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim?rev=e80a8874accd45cac90616a7b5faa49c5a68e6b9";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    omnix.url = "github:juspay/omnix";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ inputs.nixos-flake.flakeModule ];

      flake =
        let
          myUserName = "rohit";
        in
        {
          # Configurations for Linux (NixOS) machines
          nixosConfigurations.nixos = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              ./configuration.nix
              # Setup home-manager in NixOS config
              self.nixosModules.home-manager
              {
                home-manager.users.${myUserName} = {
                  imports = [ self.homeModules.default ];
                  home.stateVersion = "22.11";
                };
              }
            ];
          };

          # home-manager configuration goes here.
          homeModules.default = { pkgs, ... }: {
            imports = [
              ./terminal.nix
              ./neovim.nix
            ];

            
            nix = {

              # FIXME: Waiting for this to be merged:
              # https://github.com/nix-community/home-manager/pull/4031
              # nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
          
              # Garbage collect the Nix store
              gc = {
                automatic = true;
                # Change how often the garbage collector runs (default: weekly)
                # frequency = "monthly";
              };
            };

            programs.git = {
              enable = true;
              ignores = [ "*~" "*.swp" ];
              # Bitbucket git access and policies
              includes = [{
                condition = "gitdir:~/euler/**";
                contents = {
                  user.email = "rohit.singh@juspay.in";
                  user.name = "Rohit Singh";
                };
              }];
            };
            programs.starship.enable = true;
            programs.bash.enable = true;
            programs.tmux.enable = true;
            programs.lazygit.enable = true;
            programs.ripgrep.enable = true;
            programs.zellij.enable = true;
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
          };
        };
    };
}
