{ config, flake, pkgs, lib, ... }: {

  imports = [
    "${flake.inputs.nixos-hardware}/starfive/visionfive/v2/sd-image-installer.nix"
    flake.inputs.nixos-hardware.nixosModules.starfive-visionfive-2
  ];

  nixpkgs.buildPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.hostPlatform = lib.mkDefault "riscv64-linux";

  users = {
    users.sinrohit = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "${flake.config.me.sshKey}"
      ];
    };
  };

  environment.systemPackages = with pkgs; [ git vim ];
  nix.settings.trusted-users = [ "root" "wheel" ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nichi.co"
      "https://cache.ztier.in"
    ];
    trusted-public-keys = [
      "hydra.nichi.co-0:P3nkYHhmcLR3eNJgOAnHDjmQLkfqheGyhZ6GLrUVHwk="
      "cache.ztier.link-1:3P5j2ZB9dNgFFFVkCQWT3mh0E+S3rIWtZvoql64UaXM="
    ];
  };

  networking.hostName = "riscv";

  networking.interfaces.end0.useDHCP = true;
  networking.interfaces.end1.useDHCP = true;

  system.stateVersion = "24.11";
}

