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
  gh = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.gh;
  st = inputs.st.packages."${prev.system}".st-snazzy;

  # Want the latest version of these
  nushell = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nushell;
  nixfmt-tree = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nixfmt-tree;
  nixfmt = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nixfmt;
  rust-analyzer = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.rust-analyzer;

  nixci = inputs.nixci.packages.${prev.system}.default;

}
