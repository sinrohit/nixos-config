{
  pubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMD9wR7p/at18BWsYnw1R6m7fPhj01otDrJwaC2sYAR+"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvCnbNCc22/DeR7cZVUHv3PwwfpL6kIAHO4Ns7SMj1h"
  ];


  homeModule = { pkgs, lib, ... }: {
    home.packages = with pkgs; [ sshuttle python3 fd fzf ];

  };
}
