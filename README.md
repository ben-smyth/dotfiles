# Dependency and Dotfile Management

This repo has one root Nix flake for macOS systems, Home Manager config, and a
minimal development shell.

## New Mac Setup

Migration Assistant copies the home directory, but not the `/nix` volume, so
every Home Manager symlink (`~/.zshrc`, `~/.config/nvim`, ...) is dangling
until Nix is reinstalled and the system is switched. The config assumes an
Apple Silicon Mac (`aarch64-darwin`).

1. Install the Xcode Command Line Tools and confirm GitHub SSH access:

   ```sh
   xcode-select --install
   ssh -T git@github.com
   ```

2. Replace the migrated repo copy with a fresh clone:

   ```sh
   mv ~/dotfiles ~/dotfiles.migrated
   git clone git@github.com:ben-smyth/dotfiles.git ~/dotfiles
   ```

3. Install Nix, then open a new terminal:

   ```sh
   ~/dotfiles/nix/scripts/install_nix.sh
   ```

4. Build the system with the locked nix-darwin, then switch to it:

   ```sh
   cd ~/dotfiles
   nix --extra-experimental-features 'nix-command flakes' \
     build .#darwinConfigurations.Bens-MacBook-Pro.system
   sudo ./result/sw/bin/darwin-rebuild switch --flake .#Bens-MacBook-Pro
   rm result
   ```

   If activation aborts with "Unexpected files in /etc", rename each listed
   file and rerun the switch command:

   ```sh
   sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
   ```

5. Open a new terminal. Zinit and the Zsh plugins install on first launch,
   and Neovim plugins install from `lazy-lock.json` on first `nvim`.

6. Optionally match the host name so `update_system.sh` auto-detects the
   configuration. Do this after the old Mac is off the network:

   ```sh
   sudo scutil --set LocalHostName Bens-MacBook-Pro
   ```

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
