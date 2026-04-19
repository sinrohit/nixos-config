{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings.monitor = [ "HDMI-A-2,2560x1440@60,0x0,1" ];
  };

  home.packages = with pkgs; [ nwg-displays ];
}
