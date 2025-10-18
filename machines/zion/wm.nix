{
  pkgs,
  ...
}:
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # change window focus within space
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - h : yabai -m window --focus west
      alt - l : yabai -m window --focus east

      # change focus between external displays (left & right)
      alt - s : yabai -m display --focus west
      alt - g : yabai -m display --focus east

      # rotate layout clockwise
      shift + alt - r : yabai -m space --rotate 270

      # flip along y-axis
      shift + alt - y : yabai -m space --mirror y-axis

      # flip along x-axis
      shift + alt - x : yabai -m space --mirror x-axis

      # toggle window float
      shift + alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

      # maximize a window
      shift + alt - m : yabai -m window --toggle zoom-fullscreen

      # balance out tree of windows (resize to occupy same area)
      shift + alt - e : yabai -m space --balance

      # swap windows
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - h : yabai -m window --swap west
      shift + alt - l : yabai -m window --swap east

      # move window and split
      ctrl + alt - j : yabai -m window --warp south
      ctrl + alt - k : yabai -m window --warp north
      ctrl + alt - h : yabai -m window --warp west
      ctrl + alt - l : yabai -m window --warp east

      # move window to display left and right
      shift + alt - s : yabai -m window --display west; yabai -m display --focus west;
      shift + alt - g : yabai -m window --display east; yabai -m display --focus east;

      # move window to prev and next space
      shift + alt - p : yabai -m window --space prev;
      shift + alt - n : yabai -m window --space next;

      # move window to space #
      shift + alt - 1 : yabai -m window --space 1;
      shift + alt - 2 : yabai -m window --space 2;
      shift + alt - 3 : yabai -m window --space 3;
      shift + alt - 4 : yabai -m window --space 4;

      # stop/start/restart yabai
      ctrl + alt - q : yabai --stop-service
      ctrl + alt - s : yabai --start-service
      ctrl + alt - r : yabai --restart-service

    '';
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {

      # default layout (can be bsp, stack or float)
      layout = "bsp";

      # padding set to 12px
      top_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      window_gap = 12;

      # center mouse on window with focus
      mouse_follows_focus = "on";
      focus_follows_mouse = "autofocus";

      # modifier for clicking and dragging with mouse
      mouse_modifier = "alt";

      # set modifier + left-click drag to move window
      mouse_action1 = "move";

      # set modifier + right-click drag to resize window
      mouse_action2 = "resize";

      # when window is dropped in center of another window, swap them (on edges it will split it)
      mouse_drop_action = "sway";

      # New window spawns to the right if vertical split, or bottom if horizontal split
      window_placement = "second_child";
      window_topmost = "on";
      window_shadow = "float";
      window_border = "off";

      auto_balance = "on";
      split_ratio = 0.5;
    };

    extraConfig = ''
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Calculator' manage=off
    '';
  };
}
