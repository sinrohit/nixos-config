{ lib, ... }:

let

  users = {
    rohit = import ./rohit.nix;
    nix-infra = import ./nix-infra.nix;
  };
in
users
