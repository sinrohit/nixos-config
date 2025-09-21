{
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-shell";
        meta.description = "Shell environment for modifying this Nix configuration";
        packages = with pkgs; [
          nixd
          nil
          inputs'.agenix.packages.default
          nixos-rebuild
        ];
      };
    };
}
