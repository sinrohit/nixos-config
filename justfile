default:
    @just --list

# Auto-format tree
fmt:
    treefmt

deploy-nixos HOST:
    nixos-rebuild --flake .#{{HOST}} --target-host {{HOST}} --use-remote-sudo --fast switch

deploy-macos HOST:
    sudo darwin-rebuild switch --flake .#{{HOST}}
