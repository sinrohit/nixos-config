{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./bash.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [ cachix ];
}
