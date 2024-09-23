{ lib, ... }:

let

  users = {
    rohit = import ./rohit.nix;
  };
in
users
