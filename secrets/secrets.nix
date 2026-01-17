let
  rohit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWUINFSlhsbwckdAlvE/V1ESIk0yXdVvE/BuMEJpEvl";
  users = [ rohit ];

  clark = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMY+NmD4GBq9Haqa1iBiofEWvsmQh7KgHCP60y6TFLZq";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm4Jfv+D2mUwyEYZ+DBeEBnFFeKxMNoG4ZpvV9VXorQ";
  zion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZWNuSlFSzLHVOB59SxltjNDNLYuwKqA4iiKAf4Lo8n";
  orb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZWNuSlFSzLHVOB59SxltjNDNLYuwKqA4iiKAf4Lo8n";
  systems = [
    clark
    pi
    zion
    orb
  ];
in
{
  "acme-cloudflare.age".publicKeys = users ++ systems;
  "acme-cloudflare-sinrohit.age".publicKeys = users ++ systems;
  "github-runner-fold-macos.age".publicKeys = users ++ systems;
  "github-runner-fold-linux.age".publicKeys = users ++ systems;
  "github-runner-nixos-config-macos.age".publicKeys = users ++ systems;
  "github-runner-nixos-config-linux.age".publicKeys = users ++ systems;
  "github-runner-sinrohit.age".publicKeys = users ++ systems;
  "github-runner-nixci-macos.age".publicKeys = users ++ systems;
  "github-runner-nixci-linux.age".publicKeys = users ++ systems;
  "cloudflare-tunnel.age".publicKeys = users ++ systems;
  "cloudflare-tunnel-sinrohit.age".publicKeys = users ++ systems;
}
