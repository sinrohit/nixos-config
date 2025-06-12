# nixos-config

This repository contains the Nix / NixOS configuration for all of my systems using [flake-parts](https://github.com/hercules-ci/flake-parts).

See an overview of the flake outputs by running below command

```sh
nix flake show github:sinrohit/nixos-config
```

## Structure

-  [home](./home): Home Manager Configuration for user specific settings and packages.
-  [lib](./lib): Helper functions to create NixOS/Darwin system configurations with common settings.
-  [machines](./machines/): Host specific Configurations for different systems.
-  [modules](./modules/): Custom NixOS modules including flakes integration, xmonad configuration, etc.
-  [overlays](./overlays/): Package overlays to extend or upgrade packages
-  [pkgs](./pkgs): Custom Package definitions.
-  [secrets](./secrets/): Age-encrypted secrets management.

## Managing Secrets

This configuration uses [ragenix](github.com/yaxitech/ragenix) for secret management. Secrets are stored in secrets directory.

### Storage & Access

Secrets are stored in the Git repo as age-encrypted files. Access roles for each secret is defined in Nix, in the `./secrets/secrets.nix` file.

Read [the `agenix` tutorial](https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial) for details.

### Editing Secrets

In the nix develop shell,

```sh
agenix -e ./<secret-file>.age
```

### Authorizing new hosts or users

Add the new host to the `systems` list of `./secrets/secrets.nix` , and the new user to the `users` list of the same file, followed by running:

```sh
cd ./secrets/
agenix -r
```

The above will re-encrypt the secrets authorizing the new set of hosts and users to decrypt them.
