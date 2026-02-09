let
  rohit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWUINFSlhsbwckdAlvE/V1ESIk0yXdVvE/BuMEJpEvl";
  rohit-enigma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2I5q4joEZHECEbEhLvcH1J67NGODrCmjZXwVCoMSLo";
  users = [
    rohit
    rohit-enigma
  ];

  clark = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMY+NmD4GBq9Haqa1iBiofEWvsmQh7KgHCP60y6TFLZq";
  enigma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoJURAZ9WI8IrcAThSDhKbGtlSTnvY/YbgflaZlJXmi";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm4Jfv+D2mUwyEYZ+DBeEBnFFeKxMNoG4ZpvV9VXorQ";
  zion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZWNuSlFSzLHVOB59SxltjNDNLYuwKqA4iiKAf4Lo8n";
  orb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZWNuSlFSzLHVOB59SxltjNDNLYuwKqA4iiKAf4Lo8n";
  systems = [
    clark
    enigma
    pi
    zion
    orb
  ];
in
{
  "acme-cloudflare.age".publicKeys = users ++ systems;
  "acme-cloudflare-sinrohit.age".publicKeys = users ++ systems;
  "github-runner-nixos-config-macos.age".publicKeys = users ++ systems;
  "github-runner-nixos-config-aarch64-linux.age".publicKeys = users ++ systems;
  "github-runner-nixos-config-x86_64-linux.age".publicKeys = users ++ systems;
  "github-runner-sinrohit.age".publicKeys = users ++ systems;
  "cloudflare-tunnel.age".publicKeys = users ++ systems;
  "cloudflare-tunnel-sinrohit.age".publicKeys = users ++ systems;
  "restic.age".publicKeys = users ++ systems;
  "nextcloud-admin-passwd.age".publicKeys = users ++ systems;
}
