{ lib, config, ... }:
{

  options.aerospace.enable = lib.mkEnableOption "aerospace";

  config = lib.mkIf config.aerospace.enable {

    services.aerospace = {
      enable = true;
      settings = {
        after-startup-command = [
          "layout tiles"
        ];
        start-at-login = false;
        automatically-unhide-macos-hidden-apps = false;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        gaps = {
          outer = {
            left = 8;
            bottom = 8;
            top = 8;
            right = 8;
          };
          inner = {
            horizontal = 8;
            vertical = 8;
          };
        };
        mode.main.binding = {

          alt-t = "exec-and-forget open -a /Applications/Ghostty.app/";
          alt-b = "exec-and-forget open -a /Applications/Brave Browser.app/";

          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";

          alt-shift-1 = "move-node-to-workspace 1 --focus-follows-window";
          alt-shift-2 = "move-node-to-workspace 2 --focus-follows-window";
          alt-shift-3 = "move-node-to-workspace 3 --focus-follows-window";
          alt-shift-4 = "move-node-to-workspace 4 --focus-follows-window";
          alt-shift-5 = "move-node-to-workspace 5 --focus-follows-window";

          #alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          alt-ctrl-shift-f = "fullscreen";
          alt-ctrl-f = "layout floating tiling";

          alt-shift-left = "join-with left";
          alt-shift-down = "join-with down";
          alt-shift-up = "join-with up";
          alt-shift-right = "join-with right";
        };

        on-window-detected = [
          {
            "if".app-name-regex-substring = "ghostty";
            run = "move-node-to-workspace 2";
          }
          {
            "if".app-name-regex-substring = "finder|calendar";
            run = "layout floating";
          }
          #{
          #  "if".workspace = "1";
          #  run = "layout h_accordion";
          #}
        ];
        workspace-to-monitor-force-assignment = {
          "1" = 1;
          "2" = "main";
          "3" = "secondary";
          "4" = "built-in";
          "5" = "^built-in retina display$";
          "6" = [
            "secondary"
            "dell"
          ];
        };
      };
    };
  };
}
