{ inputs }:
/*
  This contains various packages we want to overlay. Note that the
  other ".nix" files in this directory are automatically loaded.
*/
final: prev: {
  xmobar-custom = final.callPackage ../pkgs/xmobar { };
  # gh CLI on stable has bugs.
  gh = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.gh;
  nixfmt = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nixfmt;
  nixfmt-tree = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nixfmt-tree;
  rust-analyzer = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.rust-analyzer;

  # Want the latest version of these
  nushell = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nushell;

  nixci = inputs.nixci.packages.${prev.system}.default;

}
