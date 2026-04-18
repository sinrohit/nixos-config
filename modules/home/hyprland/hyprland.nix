{ pkgs, ... }:

{
  # ── Extra packages the compositor session needs ───────────────────────
  home.packages = with pkgs; [
    # Wayland utilities
    wl-clipboard
    wl-clip-persist
    cliphist
    wf-recorder

    # Screenshot
    grim
    slurp
    grimblast

    # Color picker
    hyprpicker

    # Wallpaper
    swww

    # Notifications
    libnotify

    # App launcher
    rofi

    # Status bar
    waybar

    # Polkit agent
    polkit_gnome

    # Network applet
    networkmanagerapplet

    # Power alert
    poweralertd

    # File manager
    nautilus

    # Image viewer
    imv

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];

  # ── Hyprland via Home-Manager ─────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;

    package = null;
    portalPackage = null;

    xwayland.enable = true;
    systemd.enable = true;
  };
}
