{
  pkgs,
  ...
}:
{
  imports = [
    ./git.nix
    ./tmux.nix
    ./packages.nix
    ./direnv.nix
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
  home.packages = with pkgs; [
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
    nix-eval-jobs
    nix-output-monitor
    nixfmt
    nixci
    rust-analyzer
    lsd
    duf
  ];

  #---------------------------------------------------------------------
  # Env vars
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };
}
