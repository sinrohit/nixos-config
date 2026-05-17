{ inputs }:
/*
  This contains various packages we want to overlay. Note that the
  other ".nix" files in this directory are automatically loaded.
*/
final: prev: {
  xmobar-custom = final.callPackage ../pkgs/xmobar { };
  deploy = final.callPackage ../pkgs/deploy { };
  # gh CLI on stable has bugs.
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) gh;
  st = inputs.st.packages."${prev.system}".st-snazzy;

  # Want the latest version of these
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) nushell;
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) nixfmt-tree;
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) nixfmt;
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) rust-analyzer;
  inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) forgejo-runner;

  neovim = inputs.neovim.packages.${prev.system}.default;

  # Workaround for aarch64-darwin codesigning bug (nixpkgs#208951 / #507531):
  # fish binaries from the binary cache occasionally have invalid ad-hoc
  # signatures on Apple Silicon. Forcing a local rebuild ensures codesigning
  # is applied on this machine with a valid signature.
  fish = prev.fish.overrideAttrs (_old: {
    # Bust the cache key so fish is always built locally rather than
    # substituted from the binary cache where the signature may be stale.
    NIX_FORCE_LOCAL_REBUILD = "darwin-codesign-fix";
  });

}
