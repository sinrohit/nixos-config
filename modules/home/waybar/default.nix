let
  c = (import ../hyprland/colors.nix).gruvbox;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # ── Bar layout ────────────────────────────────────────────────────────
    settings = [
      {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;

        modules-left = [
          "custom/logo"
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "custom/media"
          "pulseaudio"
          "network"
          "bluetooth"
          "battery"
          "cpu"
          "memory"
          "temperature"
          "tray"
          "custom/notification"
        ];

        # ── Module configs ─────────────────────────────────────────────────

        "custom/logo" = {
          format = " ";
          tooltip = false;
          on-click = "rofi -show drun";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            "10" = "󰿬";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };

        "hyprland/window" = {
          format = "  {}";
          max-length = 50;
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "  $1";
            "(.*) — Brave" = "󰖟  $1";
            "ghostty" = "  Terminal";
            "nvim (.*)" = "  $1";
          };
        };

        "clock" = {
          format = "  {:%H:%M}";
          format-alt = "  {:%A, %B %d %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
        };

        "cpu" = {
          format = "  {usage}%";
          tooltip = true;
          interval = 2;
        };

        "memory" = {
          format = "  {}%";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
          interval = 2;
        };

        "temperature" = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon0/temp1_input";
          critical-threshold = 80;
          format = "{icon}  {temperatureC}°C";
          format-critical = "  {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip = true;
        };

        "network" = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "󰈀  {ipaddr}";
          format-disconnected = "󰌙  Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\nGateway: {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
          interval = 5;
        };

        "bluetooth" = {
          format = "  {status}";
          format-connected = "  {device_alias}";
          format-connected-battery = "  {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-bluetooth = "󰂯  {volume}%";
          format-muted = "󰝟  Muted";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
            headphone = "";
            headset = "󰋎";
            phone = "";
            portable = "";
          };
          on-click = "pavucontrol";
          scroll-step = 2;
          tooltip-format = "{desc}: {volume}%";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo}\n{power:.2f}W";
        };

        "tray" = {
          icon-size = 16;
          spacing = 8;
          show-passive-items = true;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}  {}";
          format-icons = {
            notification = "󰂚";
            none = "󰂜";
            dnd-notification = "󰂛";
            dnd-none = "󰪑";
            inhibited-notification = "󰂚";
            inhibited-none = "󰂜";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰪑";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/media" = {
          format = "{icon}  {}";
          return-type = "json";
          max-length = 30;
          format-icons = {
            Paused = " ";
            Playing = "󰎈 ";
            Stopped = "";
          };
          smooth-scrolling-threshold = 10;
          exec = "playerctl -a metadata --format '{\"text\": \"{{markup_escape(title)}}\", \"tooltip\": \"{{markup_escape(artist)}} — {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F 2>/dev/null";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };
      }
    ];

    # ── Gruvbox CSS ────────────────────────────────────────────────────────
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", FontAwesome, sans-serif;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: rgba(29, 32, 33, 0.85);
        color: #${c.fg1};
        border-radius: 12px;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      /* ── Workspaces ──────────────────────────────────────────────── */
      #workspaces {
        background: rgba(60, 56, 54, 0.6);
        border-radius: 10px;
        margin: 4px 4px;
        padding: 0 4px;
      }

      #workspaces button {
        color: #${c.fg4};
        padding: 0 6px;
        border-radius: 8px;
        transition: all 0.2s ease-in-out;
        background: transparent;
      }

      #workspaces button:hover {
        background: rgba(250, 189, 47, 0.2);
        color: #${c.yellow_b};
      }

      #workspaces button.active {
        background: rgba(215, 153, 33, 0.35);
        color: #${c.yellow_b};
        font-weight: bold;
      }

      #workspaces button.urgent {
        background: rgba(204, 36, 29, 0.6);
        color: #${c.red_b};
      }

      /* ── Window title ────────────────────────────────────────────── */
      #window {
        color: #${c.fg2};
        background: rgba(60, 56, 54, 0.5);
        border-radius: 10px;
        margin: 4px 4px;
        padding: 0 12px;
      }

      /* ── Clock ───────────────────────────────────────────────────── */
      #clock {
        background: rgba(215, 153, 33, 0.25);
        color: #${c.yellow_b};
        border-radius: 10px;
        margin: 4px 4px;
        padding: 0 16px;
        font-weight: bold;
      }

      /* ── Right modules: common ───────────────────────────────────── */
      #cpu, #memory, #temperature,
      #network, #bluetooth, #pulseaudio,
      #battery, #tray, #custom-notification,
      #custom-media, #custom-logo {
        background: rgba(60, 56, 54, 0.6);
        color: #${c.fg2};
        border-radius: 10px;
        margin: 4px 2px;
        padding: 0 10px;
        transition: all 0.2s ease-in-out;
      }

      #cpu        { color: #${c.aqua_b};   }
      #memory     { color: #${c.blue_b};   }
      #temperature { color: #${c.orange_b}; }
      #network    { color: #${c.green_b};  }
      #bluetooth  { color: #${c.blue_b};   }
      #pulseaudio { color: #${c.purple_b}; }

      /* ── Battery states ──────────────────────────────────────────── */
      #battery {
        color: #${c.green_b};
      }
      #battery.charging, #battery.plugged {
        color: #${c.yellow_b};
        background: rgba(215, 153, 33, 0.2);
      }
      #battery.warning:not(.charging) {
        color: #${c.orange_b};
      }
      #battery.critical:not(.charging) {
        color: #${c.red_b};
        background: rgba(204, 36, 29, 0.3);
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to { color: #${c.fg}; }
      }

      /* ── Temperature critical ────────────────────────────────────── */
      #temperature.critical {
        color: #${c.red_b};
        background: rgba(204, 36, 29, 0.3);
      }

      /* ── Custom logo ─────────────────────────────────────────────── */
      #custom-logo {
        font-size: 18px;
        color: #${c.yellow_b};
        background: rgba(215, 153, 33, 0.15);
        padding: 0 14px;
      }

      /* ── Media player ────────────────────────────────────────────── */
      #custom-media {
        color: #${c.aqua_b};
        background: rgba(104, 157, 106, 0.2);
      }
      #custom-media.Playing { color: #${c.green_b}; }
      #custom-media.Paused  { color: #${c.fg4};     }

      /* ── Notification ────────────────────────────────────────────── */
      #custom-notification {
        color: #${c.purple_b};
      }

      /* ── Tray ────────────────────────────────────────────────────── */
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: rgba(204, 36, 29, 0.3);
      }

      tooltip {
        background: rgba(29, 32, 33, 0.95);
        color: #${c.fg1};
        border: 1px solid rgba(215, 153, 33, 0.4);
        border-radius: 8px;
      }
    '';
  };
}
