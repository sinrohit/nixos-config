let
  terminal = "ghostty";
  browser = "firefox";
  fileManager = "nautilus";
  launcher = "rofi -show drun -show-icons";
  clipMenu = "cliphist list | rofi -dmenu -p '📋 Clipboard' | cliphist decode | wl-copy";
  colorPicker = "hyprpicker -a";
  screenshot = "grimblast --notify copy area";
  screenFull = "grimblast --notify copy screen";
  screenWin = "grimblast --notify copy active";
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    # ══════════════════════════════════════════════════════════════════════
    #                              BINDS
    # ══════════════════════════════════════════════════════════════════════

    $mod = SUPER

    # ── Apps ─────────────────────────────────────────────────────────────
    bind = $mod,       Return,    exec, ${terminal}
    bind = $mod,       B,         exec, ${browser}
    bind = $mod,       E,         exec, ${fileManager}
    bind = $mod,       Space,     exec, ${launcher}
    bind = $mod,       V,         exec, bash -c "${clipMenu}"
    bind = $mod SHIFT, C,         exec, ${colorPicker}

    # ── Screenshots ───────────────────────────────────────────────────────
    bind  = ,          Print,     exec, ${screenshot}
    bind  = SHIFT,     Print,     exec, ${screenFull}
    bind  = ALT,       Print,     exec, ${screenWin}

    # ── Window management ─────────────────────────────────────────────────
    bind = $mod,       Q,         killactive
    bind = $mod SHIFT, Q,         exit
    bind = $mod,       F,         fullscreen, 0
    bind = $mod SHIFT, F,         fullscreen, 1       # Maximize (keep bar)
    bind = $mod,       P,         pseudo
    bind = $mod,       J,         togglesplit
    bind = $mod,       T,         togglefloating
    bind = $mod,       G,         togglegroup
    bind = $mod TAB,   ,          changegroupactive, f
    bind = $mod SHIFT TAB, ,      changegroupactive, b
    bind = $mod,       Z,         pin                 # Pin float on top

    # ── Focus — vim-style hjkl ────────────────────────────────────────────
    bind = $mod, H,    movefocus, l
    bind = $mod, L,    movefocus, r
    bind = $mod, K,    movefocus, u
    bind = $mod, J,    movefocus, d

    # Arrow keys as well
    bind = $mod, left,  movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up,    movefocus, u
    bind = $mod, down,  movefocus, d

    # ── Move windows ──────────────────────────────────────────────────────
    bind = $mod SHIFT, H,     movewindow, l
    bind = $mod SHIFT, L,     movewindow, r
    bind = $mod SHIFT, K,     movewindow, u
    bind = $mod SHIFT, J,     movewindow, d

    bind = $mod SHIFT, left,  movewindow, l
    bind = $mod SHIFT, right, movewindow, r
    bind = $mod SHIFT, up,    movewindow, u
    bind = $mod SHIFT, down,  movewindow, d

    # ── Resize ────────────────────────────────────────────────────────────
    bind = $mod CTRL, H,      resizeactive, -50 0
    bind = $mod CTRL, L,      resizeactive,  50 0
    bind = $mod CTRL, K,      resizeactive,  0 -50
    bind = $mod CTRL, J,      resizeactive,  0  50

    bind = $mod CTRL, left,   resizeactive, -50 0
    bind = $mod CTRL, right,  resizeactive,  50 0
    bind = $mod CTRL, up,     resizeactive,  0 -50
    bind = $mod CTRL, down,   resizeactive,  0  50

    # ── Workspaces ────────────────────────────────────────────────────────
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    # Move window to workspace
    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10

    # Move window silently (stay on current workspace)
    bind = $mod ALT, 1, movetoworkspacesilent, 1
    bind = $mod ALT, 2, movetoworkspacesilent, 2
    bind = $mod ALT, 3, movetoworkspacesilent, 3
    bind = $mod ALT, 4, movetoworkspacesilent, 4
    bind = $mod ALT, 5, movetoworkspacesilent, 5

    # Scroll through workspaces
    bind = $mod, mouse_down, workspace, e+1
    bind = $mod, mouse_up,   workspace, e-1
    bind = $mod, bracketright, workspace, e+1
    bind = $mod, bracketleft,  workspace, e-1

    # Special workspace (scratchpad)
    bind = $mod,       S,     togglespecialworkspace, scratchpad
    bind = $mod SHIFT, S,     movetoworkspace, special:scratchpad

    # ── Mouse binds ───────────────────────────────────────────────────────
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow

    # ── Media / Volume ────────────────────────────────────────────────────
    bindel = , XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bindel = , XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindl  = , XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindl  = , XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    bindl  = , XF86AudioPlay,         exec, playerctl play-pause
    bindl  = , XF86AudioNext,         exec, playerctl next
    bindl  = , XF86AudioPrev,         exec, playerctl previous

    # ── Brightness ────────────────────────────────────────────────────────
    bindel = , XF86MonBrightnessUp,   exec, brightnessctl set 5%+
    bindel = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

    # ── Session ───────────────────────────────────────────────────────────
    bind = $mod SHIFT, L, exec, hyprlock
    bind = $mod SHIFT, M, exec, wlogout --protocol layer-shell

    # Notification center
    bind = $mod,       N,     exec, swaync-client -t -sw

    # Reload waybar
    bind = $mod SHIFT, W,     exec, killall -SIGUSR2 waybar
  '';
}
