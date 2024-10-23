{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    ./configuration.nix
  ];

  # Remote access
  # - SSH through tailscale
  # - Allow passwordless sudo for all in 'wheel'
  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--advertise-exit-node" ];
  };
  virtualisation.docker.enable = true;
  
  # Some machines may not have ethernet.
  networking.networkmanager.enable = true;
}
