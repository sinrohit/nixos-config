let
  rohit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWUINFSlhsbwckdAlvE/V1ESIk0yXdVvE/BuMEJpEvl";
  users = [ rohit ];

  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm4Jfv+D2mUwyEYZ+DBeEBnFFeKxMNoG4ZpvV9VXorQ";
  zion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZWNuSlFSzLHVOB59SxltjNDNLYuwKqA4iiKAf4Lo8n";
  systems = [
    pi
    zion
  ];
in
{
  "acme-cloudflare.age".publicKeys = users ++ systems;
  "github-runner.age".publicKeys = users ++ systems;
}
