let
  rohit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWUINFSlhsbwckdAlvE/V1ESIk0yXdVvE/BuMEJpEvl";
  users = [ rohit ];

  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm4Jfv+D2mUwyEYZ+DBeEBnFFeKxMNoG4ZpvV9VXorQ";
  zion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZWNuSlFSzLHVOB59SxltjNDNLYuwKqA4iiKAf4Lo8n";
  orb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZWNuSlFSzLHVOB59SxltjNDNLYuwKqA4iiKAf4Lo8n";
  systems = [
    pi
    zion
    orb
  ];
in
{
  "acme-cloudflare.age".publicKeys = users ++ systems;
  "github-runner-fold-macos.age".publicKeys = users ++ systems;
  "github-runner-fold-linux.age".publicKeys = users ++ systems;
  "github-runner-nixos-config-macos.age".publicKeys = users ++ systems;
  "github-runner-nixos-config-linux.age".publicKeys = users ++ systems;
  "github-runner-sinrohit.age".publicKeys = users ++ systems;
  "github-runner-nixci-macos.age".publicKeys = users ++ systems;
  "github-runner-nixci-linux.age".publicKeys = users ++ systems;
}
