_:
let
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

  };
in
{

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
    inherit shellAliases;
  };
}
