{ ... }:
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
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellOptions = [ ];
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    initExtra = builtins.readFile ./bashrc;
    shellAliases = shellAliases;
  };
}
