{ inputs }:
/*
  This contains various packages we want to overlay. Note that the
  other ".nix" files in this directory are automatically loaded.
*/
final: prev: {
  xmobar-custom = final.callPackage ../pkgs/xmobar { };
  chadwm = final.callPackage ../pkgs/chadwm { };
  deploy = final.callPackage ../pkgs/deploy { };
  # gh CLI on stable has bugs.
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) gh;
  st = inputs.st.packages."${prev.system}".st-snazzy;

  # Want the latest version of these
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) nushell;
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) nixfmt-tree;
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) nixfmt;
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) rust-analyzer;

  nixci = inputs.nixci.packages.${prev.system}.default;

}
