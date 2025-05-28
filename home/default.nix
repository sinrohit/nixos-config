{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in
{
  imports = [
    ./shell.nix
    ./git.nix
    ./tmux.nix
    ./packages.nix
    ./terminal.nix
    ./direnv.nix
    ./helix.nix
  ];

  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "18.09";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages =
    with pkgs;
    [
      asciinema
      bat
      eza
      fd
      fzf
      gh
      htop
      btop
      jq
      ripgrep
      sentry-cli
      tree
      watch
      nixfmt-tree
      neovim
      rustfmt
      fourmolu
      zls
      nil
      nixd
    ]
    ++ (lib.optionals isDarwin [
      # This is automatically setup on Linux
      cachix
    ])
    ++ (lib.optionals isLinux [
      firefox
      rofi
      valgrind
      zathura
      xfce.xfce4-terminal
    ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

  xdg.configFile =
    {
      "rofi/config.rasi".text = builtins.readFile ./rofi;
    }
    // (
      if isDarwin then
        {
          # Rectangle.app. This has to be imported manually using the app.
          "rectangle/RectangleConfig.json".text = builtins.readFile ./RectangleConfig.json;
        }
      else
        { }
    )
    // (
      if isLinux then
        {
          "ghostty/config".text = builtins.readFile ./ghostty.linux;
        }
      else
        { }
    );

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf isLinux {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
