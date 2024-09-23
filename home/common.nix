# home-manager configuration common to all users
{ flake, pkgs, ... }:
{
  imports = [
    flake.inputs.nix-index-database.hmModules.nix-index
  ];

  # Everyone uses git. But they can customize it further in their per-user
  # config.
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
  };

  home.packages = with pkgs; [
    omnix

    # TODO: This should be installed only for admins
    (pkgs.writeShellApplication {
      name = "zellij-admin";
      runtimeInputs = [ pkgs.zellij ];
      text = ''
        set -xe
        zellij attach -c admin
      '';
    })
  ];

  # Recommended Nix settings
  nix = {
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # https://yusef.napora.org/blog/pinning-nixpkgs-flake/

    # FIXME: Waiting for this to be merged:
    # https://github.com/nix-community/home-manager/pull/4031
    # nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    # Garbage collect the Nix store
    gc = {
      automatic = true;
      # Change how often the garbage collector runs (default: weekly)
      frequency = "monthly";
    };
  };

  # Let's give them a standard shell prompt.
  programs.starship = {
    enable = true;
    settings = {
      username = {
        style_user = "blue bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "🌐 ";
        format = "on [$hostname](bold red) ";
        trim_at = ".local";
        disabled = false;
      };
    };
  };

  # https://nixos.asia/en/direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # For macOS's default shell.
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      # Make Nix and home-manager installed things available in PATH.
      export PATH=/run/wrappers/bin:/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH

      eval "$(zoxide init --cmd cd zsh)"
    '';
  };

  # Enable bash, so the dotfiles are in use.
  programs.bash = {
    enable = true;
  };

  # command-not-found handler to suggest nix way of installing stuff.
  # FIXME: This ought to show new nix cli commands though:
  # https://github.com/nix-community/nix-index/issues/191
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  # Useful programs
  programs.htop.enable = true;
}
