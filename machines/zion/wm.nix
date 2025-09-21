{
  services.skhd = {
    enable = true;
    # CMD is Super
    skhdConfig = ''
      cmd - s: screencapture -c
      cmd - return : /Applications/Alacritty.app/Contents/MacOS/alacritty --working-directory ~

      cmd - left : yabai -m window --focus west
      cmd - right : yabai -m window --focus east
      cmd - up : yabai -m window --focus north
      cmd - down : yabai -m window --focus south

      cmd + shift - left : yabai -m window --swap west
      cmd + shift - right : yabai -m window --swap east
      cmd + shift - up : yabai -m window --swap north
      cmd + shift - down : yabai -m window --swap south

      cmd - 1 : yabai -m display --focus 1
      cmd - 2 : yabai -m display --focus 2
      cmd - 3 : yabai -m display --focus 3
      cmd - 4 : yabai -m display --focus 4
      cmd - 5 : yabai -m display --focus 5
      cmd - 6 : yabai -m display --focus 6
      cmd - 7 : yabai -m display --focus 7
      cmd - 8 : yabai -m display --focus 8
      cmd - 9 : yabai -m display --focus 9
      cmd - 0 : yabai -m display --focus 10

      cmd + shift - 1 : yabai -m window --display 1; yabai -m display --focus 1
      cmd + shift - 2 : yabai -m window --display 2; yabai -m display --focus 2
      cmd + shift - 3 : yabai -m window --display 3; yabai -m display --focus 3
      cmd + shift - 4 : yabai -m window --display 4; yabai -m display --focus 4
      cmd + shift - 5 : yabai -m window --display 5; yabai -m display --focus 5
      cmd + shift - 6 : yabai -m window --display 6; yabai -m display --focus 6
      cmd + shift - 7 : yabai -m window --display 7; yabai -m display --focus 7
      cmd + shift - 8 : yabai -m window --display 8; yabai -m display --focus 8
      cmd + shift - 9 : yabai -m window --display 9; yabai -m display --focus 9
      cmd + shift - 0 : yabai -m window --display 10; yabai -m display --focus 10

      cmd + alt - 1: displayplacer "id:4FA81399-C168-BDED-6B38-53851AC566CD res:1920x1080 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:E355FDB7-6122-50FF-7C47-22E7B65AC275 res:1920x1080 hz:60 color_depth:8 scaling:off origin:(0,-1080) degree:0" "id:FAC09570-592F-CA89-4057-4825CF51B3D1 res:1920x1080 hz:60 color_depth:8 scaling:off origin:(-1920,-1080) degree:0" "id:5ADCF2B5-AB50-2DB4-3A7D-14FE55D14FE8 res:1920x1080 hz:60 color_depth:8 scaling:off origin:(-1920,0) degree:0"
    '';
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      external_bar = "main:32:0";

      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "sway";

      layout = "bsp";
      top_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      window_gap = 6;

      focus_follows_mouse = "autofocus";
      mouse_follows_focus = "on";

      window_topmost = "on";
      window_shadow = "float";
      window_placement = "second_child";
      window_border = "off";

      auto_balance = "on";
      split_ratio = 0.5;
    };
  };
}
