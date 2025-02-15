let
  rohit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWUINFSlhsbwckdAlvE/V1ESIk0yXdVvE/BuMEJpEvl";
  users = [ rohit ];
  
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH7XfzR41VnfOP4Dh6Jxkew6Jz1BA9zAaXZMieAC9BSp";
  systems = [ pi ];
in
{
  "acme-cloudflare.age".publicKeys = [ rohit pi ];
  "ddns-cloudflare.age".publicKeys = [ rohit pi ];
}
