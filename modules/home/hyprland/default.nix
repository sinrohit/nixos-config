{ pkgs, ... }:

{
  imports = [
    ./binds.nix
    ./exec-once.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./monitors.nix
    ../rofi
    ./rules.nix
    ./settings.nix
    ./gtk.nix
    ./variables.nix
    ../waybar
  ];

  home.packages = with pkgs; [
    blueman
    brightnessctl
    pavucontrol
    playerctl
    wlogout
  ];
}
