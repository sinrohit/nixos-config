{
  config,
  pkgs,
  ...
}:

let
  c = (import ../hyprland/colors.nix).gruvbox;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "ghostty";

    extraConfig = {
      modi = "drun,run,filebrowser,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      font = "JetBrainsMono Nerd Font 13";
      drun-display-format = "{name}";
      disable-history = false;
      sort = true;
      sorting-method = "fzf";
      case-sensitive = false;
      cycle = true;
      sidebar-mode = false;
      hover-select = true;
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
      window-thumbnail = true;
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        # ── Global properties ──────────────────────────────────────────────
        "*" = {
          bg-col = mkLiteral "rgba(29, 32, 33, 0.93)";
          bg-col-light = mkLiteral "rgba(60, 56, 54, 0.85)";
          border-col = mkLiteral "rgba(215, 153, 33, 0.7)";
          selected-col = mkLiteral "rgba(215, 153, 33, 0.25)";
          fg-col = mkLiteral "#${c.fg1}";
          fg-col2 = mkLiteral "#${c.fg4}";
          accent-col = mkLiteral "#${c.yellow_b}";
          urgent-col = mkLiteral "#${c.red_b}";

          width = 600;
          font = mkLiteral ''"JetBrainsMono Nerd Font 13"'';
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg-col";
          border = 0;
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "window" = {
          background-color = mkLiteral "@bg-col";
          border = mkLiteral "2px solid";
          border-color = mkLiteral "@border-col";
          border-radius = mkLiteral "14px";
          padding = mkLiteral "20px";
          width = mkLiteral "600px";
          x-offset = 0;
          y-offset = 0;
        };

        "mainbox" = {
          children = map mkLiteral [
            "inputbar"
            "listview"
          ];
          spacing = mkLiteral "10px";
        };

        "inputbar" = {
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
          background-color = mkLiteral "@bg-col-light";
          border-radius = mkLiteral "10px";
          padding = mkLiteral "8px 12px";
        };

        "prompt" = {
          text-color = mkLiteral "@accent-col";
          padding = mkLiteral "0 8px 0 0";
          enabled = true;
        };

        "entry" = {
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "transparent";
          placeholder = "Search...";
          placeholder-color = mkLiteral "@fg-col2";
        };

        "listview" = {
          background-color = mkLiteral "transparent";
          columns = 1;
          lines = 8;
          scrollbar = false;
          spacing = mkLiteral "4px";
        };

        "element" = {
          padding = mkLiteral "8px 12px";
          border-radius = mkLiteral "8px";
          spacing = mkLiteral "10px";
          cursor = mkLiteral "pointer";
        };

        "element normal.normal" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg-col";
        };

        "element normal.urgent" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@urgent-col";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@accent-col";
        };

        "element selected.urgent" = {
          background-color = mkLiteral "@urgent-col";
          text-color = mkLiteral "@fg-col";
        };

        "element-icon" = {
          size = mkLiteral "28px";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          highlight = mkLiteral "bold #${c.yellow_b}";
        };

        "message" = {
          enabled = false;
        };
      };
  };
}
