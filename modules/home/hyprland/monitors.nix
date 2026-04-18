{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings.monitor = [ ",preferred,auto,auto" ];
  };

  home.packages = with pkgs; [ nwg-displays ];
}
