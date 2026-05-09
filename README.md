# Dependency and Dotfile Management

This repo has one root Nix flake for macOS systems, Home Manager config, and a
minimal development shell.

## Darwin Systems

Build a system without applying it:

```sh
nix/scripts/update_system.sh Bens-MacBook-Pro --no-update --build-only
```

Apply a system:

```sh
sudo darwin-rebuild switch --flake .#Bens-MacBook-Pro
```

The available configurations are:

```sh
Bens-MacBook-Pro
bens-macbook
```

## Updates

Update Nix inputs, build, then switch:

```sh
nix/scripts/update_system.sh Bens-MacBook-Pro
```

Rebuild from the existing lock file:

```sh
nix/scripts/update_system.sh Bens-MacBook-Pro --no-update
```

Apply only Home Manager user files, packages, and symlinks:

```sh
nix/scripts/update_home.sh bensmyth
```

From an interactive shell, the equivalent helper is:

```sh
hmup
```

Read Home Manager news for this flake:

```sh
hmnews
```

Build only:

```sh
nix/scripts/update_system.sh Bens-MacBook-Pro --build-only
```

Update Neovim plugins separately:

```sh
nix/scripts/update_neovim.sh
```

Zsh plugins are still managed by Zinit and can be updated from an interactive
shell:

```sh
updateShellPlugins
```

Target a smaller update when needed:

```sh
nix flake update nixpkgs home-manager nix-darwin
nix flake update homebrew-core homebrew-cask homebrew-bundle
nix flake update catppuccin-tmux tokyo-night-tmux
```

## Minimal Shell

Start the lightweight shell from the root flake:

```sh
nix develop
```
