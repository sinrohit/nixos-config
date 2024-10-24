default:
    @just --list

# Auto-format tree
fmt:
    nix fmt

# Deploy the given machine (e.g.: `just deploy enigma`)
deploy HOST:
    nix run .#activate {{HOST}}
