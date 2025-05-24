{ inputs }:
/*
  This contains various packages we want to overlay. Note that the
  other ".nix" files in this directory are automatically loaded.
*/
final: prev: {
  xmobar-custom = final.callPackage ../pkgs/xmobar { };
  # gh CLI on stable has bugs.
  gh = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.gh;

  # Want the latest version of these
  nushell = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nushell;

}
