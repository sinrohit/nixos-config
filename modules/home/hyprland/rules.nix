{
  wayland.windowManager.hyprland.extraConfig = ''
    # ══════════════════════════════════════════════════════════════════════
    #                           WINDOW RULES v2
    # ══════════════════════════════════════════════════════════════════════

    # ── Floating windows ──────────────────────────────────────────────────
    windowrulev2 = float, class:(pavucontrol)
    windowrulev2 = float, class:(blueman-manager)
    windowrulev2 = float, class:(nm-connection-editor)
    windowrulev2 = float, class:(xdg-desktop-portal-gtk)
    windowrulev2 = float, class:(file-roller)
    windowrulev2 = float, class:(imv)
    windowrulev2 = float, class:(mpv)
    windowrulev2 = float, class:(com.github.wwmm.easyeffects)
    windowrulev2 = float, class:(org.gnome.Calculator)
    windowrulev2 = float, class:(org.gnome.Nautilus), title:(Properties)
    windowrulev2 = float, title:(Picture-in-Picture)
    windowrulev2 = float, title:(Firefox — Sharing Indicator)

    # Dialogs and pop-ups
    windowrulev2 = float, class:(xdg-desktop-portal)
    windowrulev2 = float, title:^(Open File)(.*)$
    windowrulev2 = float, title:^(Select a File)(.*)$
    windowrulev2 = float, title:^(Save As)(.*)$
    windowrulev2 = float, title:^(Confirm)(.*)$

    # ── Sizing ────────────────────────────────────────────────────────────
    windowrulev2 = size 800 600, class:(pavucontrol)
    windowrulev2 = size 900 600, class:(blueman-manager)
    windowrulev2 = size 80% 80%, class:(imv)
    windowrulev2 = size 80% 80%, class:(mpv)

    # ── Center floats ─────────────────────────────────────────────────────
    windowrulev2 = center, class:(pavucontrol)
    windowrulev2 = center, class:(blueman-manager)
    windowrulev2 = center, class:(imv)
    windowrulev2 = center, class:(mpv)
    windowrulev2 = center, title:^(Open File)(.*)$

    # ── Opacity / blur ────────────────────────────────────────────────────
    windowrulev2 = opacity 0.92, class:(ghostty)
    windowrulev2 = opacity 0.92, class:(Alacritty)
    windowrulev2 = opacity 0.95, class:(Code)
    windowrulev2 = opacity 0.95, class:(VSCodium)
    windowrulev2 = opacity 0.95, class:(discord)

    # ── Workspace assignments ─────────────────────────────────────────────
    windowrulev2 = workspace 2 silent, class:(firefox)
    windowrulev2 = workspace 3 silent, class:(discord)
    windowrulev2 = workspace 4 silent, class:(Spotify)
    windowrulev2 = workspace 9 silent, class:(org.gnome.Nautilus)

    # ── Telegram / Signal (float + right side) ────────────────────────────
    windowrulev2 = float,           class:(org.telegram.desktop)
    windowrulev2 = size 400 700,    class:(org.telegram.desktop)
    windowrulev2 = move 100%-420 50, class:(org.telegram.desktop)

    # ── Picture-in-picture ────────────────────────────────────────────────
    windowrulev2 = float,            title:(Picture-in-Picture)
    windowrulev2 = pin,              title:(Picture-in-Picture)
    windowrulev2 = size 640 360,     title:(Picture-in-Picture)
    windowrulev2 = move 100%-650 50, title:(Picture-in-Picture)

    # ── No border on fullscreen ───────────────────────────────────────────
    windowrulev2 = noborder, fullscreen:1

    # ── Idle inhibit for media ────────────────────────────────────────────
    windowrulev2 = idleinhibit fullscreen, class:(mpv)
    windowrulev2 = idleinhibit fullscreen, class:(firefox)
    windowrulev2 = idleinhibit fullscreen, class:(Spotify)
    windowrulev2 = idleinhibit focus,      class:(mpv)

    # ── XWayland fixes ────────────────────────────────────────────────────
    windowrulev2 = rounding 0, xwayland:1, floating:1
    windowrulev2 = center,     xwayland:1, floating:1, title:(.*)(Steam)

    # ══════════════════════════════════════════════════════════════════════
    #                           LAYER RULES
    # ══════════════════════════════════════════════════════════════════════

    layerrule = blur,       waybar
    layerrule = ignorezero, waybar
    layerrule = blur,       rofi
    layerrule = ignorezero, rofi
    layerrule = blur,       swaync-notification-window
    layerrule = ignorezero, swaync-notification-window
    layerrule = blur,       swaync-control-center
    layerrule = ignorezero, swaync-control-center
  '';
}
