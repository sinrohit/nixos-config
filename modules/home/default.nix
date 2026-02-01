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

  home = {

    packages = with pkgs; [
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

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      EDITOR = "nvim";
      PAGER = "less -FirSwX";
    };

    # Home-manager 22.11 requires this be set. We never set it so we have
    # to use the old state version.
    stateVersion = "18.09";
  };
}
