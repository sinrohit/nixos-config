{ inputs, ... }:
{

  perSystem =
    {
      pkgs,
      inputs',
      config,
      system,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-shell";
        meta.description = "Shell environment for modifying this Nix configuration";
        inputsFrom = [ config.pre-commit.devShell ];
        packages = with pkgs; [
          nixd
          nil
          inputs'.agenix.packages.default
          nixos-rebuild
          just
        ];
      };

      pre-commit = {
        check.enable = true;
        pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        settings.hooks = {
          statix.enable = true;
          deadnix.enable = true;
          shellcheck.enable = true;
          nixfmt.enable = true;
        };
      };
    };
}
