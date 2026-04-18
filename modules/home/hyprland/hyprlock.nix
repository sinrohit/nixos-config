{ config, ... }:

let
  c = (import ./colors.nix).gruvbox;
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        fractional_scaling = 0;
      };

      background = [
        {
          # If you set a wallpaper with swww, hyprlock can read it.
          # Alternatively point this to a file:
          #   path = "${config.home.homeDirectory}/wallpapers/gruvbox.jpg";
          path = "screenshot"; # blurs your current screen
          blur_passes = 2;
          blur_size = 6;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      # ── Clock ──────────────────────────────────────────────────────────
      label = [
        {
          text = ''cmd[update:1000] echo "$(date +'%H:%M')"'';
          color = "rgba(${c.fg1}e6)";
          font_size = 110;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:60000] echo "$(date +'%A, %B %d')"'';
          color = "rgba(${c.fg3}cc)";
          font_size = 22;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          text = " $USER";
          color = "rgba(${c.fg1}ff)";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, -145";
          halign = "center";
          valign = "center";
        }
      ];

      # ── User avatar ────────────────────────
      image = [
        {
          path = "${config.home.homeDirectory}/.face";
          size = 90;
          rounding = -1; # full circle
          border_size = 3;
          border_color = "rgba(${c.yellow}ff)";
          position = "0, -60";
          halign = "center";
          valign = "center";
        }
      ];

      # ── Password input ─────────────────────────────────────────────────
      input-field = [
        {
          size = "350, 55";
          outline_thickness = 3;
          dots_size = 0.25;
          dots_spacing = 0.4;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgba(${c.yellow}cc)";
          inner_color = "rgba(${c.bg1}cc)";
          font_color = "rgba(${c.fg1}ff)";
          fade_on_empty = false;
          placeholder_text = "<span foreground='##${c.fg4}'>Password...</span>";
          hide_input = false;
          rounding = 10;
          check_color = "rgba(${c.green_b}ff)";
          fail_color = "rgba(${c.red_b}ff)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;
          position = "0, -220";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
