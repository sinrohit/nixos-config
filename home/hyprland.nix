{ pkgs, lib, ... }:
{
  home.file.".config/hypr".source = "./hyprland/hypr";
  home.file.".config/waybar".source = "./hyprland/waybar";
  home.file.".config/foot".source = "./hyprland/foot";
}
