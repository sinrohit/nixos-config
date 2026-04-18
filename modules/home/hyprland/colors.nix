{
  gruvbox = rec {
    # ── Backgrounds ──────────────────────────────────────────────────────
    bg = "282828"; # Hard dark background
    bg0_h = "1d2021"; # Harder background
    bg0 = "282828";
    bg0_s = "32302f"; # Soft background
    bg1 = "3c3836";
    bg2 = "504945";
    bg3 = "665c54";
    bg4 = "7c6f64";

    # ── Foregrounds ──────────────────────────────────────────────────────
    fg = "ebdbb2";
    fg0 = "fbf1c7";
    fg1 = "ebdbb2";
    fg2 = "d5c4a1";
    fg3 = "bdae93";
    fg4 = "a89984";

    # ── Colors ───────────────────────────────────────────────────────────
    red = "cc241d";
    red_b = "fb4934"; # Bright red
    green = "98971a";
    green_b = "b8bb26";
    yellow = "d79921";
    yellow_b = "fabd2f";
    blue = "458588";
    blue_b = "83a598";
    purple = "b16286";
    purple_b = "d3869b";
    aqua = "689d6a";
    aqua_b = "8ec07c";
    orange = "d65d0e";
    orange_b = "fe8019";
    gray = "928374";
    gray_b = "a89984";

    # ── Hyprland rgba() helpers ──────────────────────────────────────────
    # Usage in extraConfig: "rgba(${c.hl}ee)"
    hl = "fabd2f"; # highlight / accent  (yellow-bright)
    border_active = "d79921ff";
    border_inactive = "3c3836ff";
    border_group = "b16286ff";
  };
}
