{ lib, ... }:
{
  imports = [
    ./darwin.nix
    ./nixos.nix
  ];

  options.flake.mkSystem = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = { };
    description = "System builders for different platforms";
  };
}
