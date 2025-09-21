{ pkgs, lib, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  shellAliases = {
    ga = "git add";
    gc = "git commit";
    gco = "git checkout";
    gcp = "git cherry-pick";
    gdiff = "git diff";
    gl = "git prettylog";
    gp = "git push";
    gs = "git status";
    gt = "git tag";

    lg = "lazygit";

  }
  // (
    if isLinux then
      {
        # keep it consistent with MacOS
        pbcopy = "xclip";
        pbpaste = "xclip -o";
      }
    else
      { }
  );
in
{

  programs.bash = {
    enable = true;
    shellOptions = [ ];
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    initExtra = builtins.readFile ./bashrc;
    shellAliases = shellAliases;
  };
  # Better shell prmot!
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

  # For macOS's default shell.
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      # Make Nix and home-manager installed things available in PATH.
      export PATH=/run/wrappers/bin:/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      eval "$(zoxide init --cmd cd zsh)"
    '';
    shellAliases = shellAliases;
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    shellAliases = shellAliases;
  };
}
