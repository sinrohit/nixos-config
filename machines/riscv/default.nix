{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{

  imports = [
    # Uncomment to build sd-Image
    # "${flake.inputs.nixos-hardware}/starfive/visionfive/v2/sd-image-installer.nix"
    inputs.nixos-hardware.nixosModules.starfive-visionfive-2
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  nixpkgs.buildPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.hostPlatform = lib.mkDefault "riscv64-linux";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings = {
    substituters = [
      "https://cache.nichi.co"
      "https://cache.ztier.in"
      "https://cache.clan.lol"
    ];
    trusted-public-keys = [
      "hydra.nichi.co-0:P3nkYHhmcLR3eNJgOAnHDjmQLkfqheGyhZ6GLrUVHwk="
      "cache.ztier.link-1:3P5j2ZB9dNgFFFVkCQWT3mh0E+S3rIWtZvoql64UaXM="
      "cache.clan.lol-1:3KztgSAB5R1M+Dz7vzkBGzXdodizbgLXGXKXlcQLA28="
    ];
  };

  networking.hostName = "riscv";

  services.openssh.enable = true;
  services.tailscale.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking.interfaces.end0.useDHCP = true;
  networking.interfaces.end1.useDHCP = true;

  system.stateVersion = "24.11";
}
