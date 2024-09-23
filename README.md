# nixos-config

This repository contains the Nix / NixOS configuration for all of my systems. See [nixos-flake](https://community.flake.parts/nixos-flake) if you wish to create your own configuration from scratch.

## Getting started

### Deploying

This is how we update its configuration:

```
# SSH to enigma (via tailscale)
ssh rohit@enigma
> cd /etc/nixos
# ^ This points to this git repository
> nix run
# ^ This runs 'nixos-rebuild switch' (via nixos-flake)
```
