# Configuration common to all Linux systems
{ flake, ... }:

let
  inherit (flake) config inputs;
  inherit (inputs) self;
in
{
  imports = [
    {
      users.users."rohit".isNormalUser = true;
      home-manager.users."rohit" = {
        home.stateVersion = "22.11";
      };
      home-manager.sharedModules = [
        self.homeModules.default
      ];
    }
  ];
}
