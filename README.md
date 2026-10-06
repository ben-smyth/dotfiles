# Dependency and Dotfile Management

One Nix flake drives Home Manager for each Mac. Homebrew handles Mac apps
through Brewfiles. There is no nix-darwin: nothing runs as root and nothing
in `/etc` is managed.

## Where Things Go

| What | Where |
|---|---|
| Command-line tools for every Mac | `nix/modules/home/packages.nix` |
| Command-line tools for one Mac | `nix/hosts/<host>/default.nix` |
| Mac GUI apps (casks) for every Mac | `homebrew/Brewfile` |
| Casks, App Store apps, odd formulae for one Mac | `homebrew/<host>.Brewfile` |
| Dotfiles | `dotfiles/`, linked by `nix/modules/home/files.nix` |
| macOS user settings (Dock, Finder, ...) | `nix/modules/home/macos.nix` or the host file |
| Tools for one project | that project's dev shell, not this repo |

Try a tool without installing it:

```sh
nix shell nixpkgs#<package>
```

Avoid `brew install`, `npm -g`, `pipx install` and `go install` for anything
you want to keep. Every update run lists Homebrew packages that are installed
but not in a Brewfile.

## Machines

| Configuration | User | Host files |
|---|---|---|
| `bensmyth` | work MacBook Pro | `nix/hosts/fluxm4p`, `homebrew/fluxm4p.Brewfile` |
| `admin` | personal MacBook | `nix/hosts/bennym4p`, `homebrew/bennym4p.Brewfile` |

The scripts pick the configuration from the current user name.

## Updates

Update flake inputs, apply Home Manager, then apply the Brewfile:

```sh
nix/scripts/update_system.sh
```

Do the same from the existing lock file:

```sh
nix/scripts/update_system.sh --no-update
```

Build without applying:

```sh
nix/scripts/update_system.sh --no-update --build-only
```

Apply only Home Manager (dotfiles, CLI tools, settings), from a shell:

```sh
hmup
```

Remove Homebrew packages that are not in any Brewfile:

```sh
brew bundle cleanup --global --force
```

Other helpers:

```sh
hmnews                          # Home Manager news
nix/scripts/update_neovim.sh    # Neovim plugins
updateShellPlugins              # Zinit and Zsh plugins
nix flake update nixpkgs home-manager
```

## New Mac Setup

Run each step on its own and wait for it to finish.

1. Accept the Xcode license if Xcode was migrated, then check GitHub access:

   ```sh
   sudo xcodebuild -license accept
   ssh -T git@github.com
   ```

2. Clone the repo:

   ```sh
   git clone git@github.com:ben-smyth/dotfiles.git ~/dotfiles
   ```

3. Install Nix, answer yes to its prompts, then open a new terminal:

   ```sh
   ~/dotfiles/nix/scripts/install_nix.sh
   ```

4. After Migration Assistant only: remove Nix leftovers that point into the
   old machine's `/nix` store:

   ```sh
   rm -rf ~/.nix-profile ~/.local/state/nix ~/.local/state/home-manager ~/.cache/nix
   rm -f ~/Applications/"Home Manager Apps"
   ```

   Also replace the migrated Nix daemon service, which points at a nix-daemon
   in the old store. Without this, `nix` fails with "opening lock file
   /nix/var/nix/db/big-lock: Permission denied". The last two lines remove
   old nix-darwin and Determinate boot jobs that can no longer run.

   ```sh
   sudo launchctl bootout system/org.nixos.nix-daemon
   sudo cp /nix/var/nix/profiles/default/Library/LaunchDaemons/org.nixos.nix-daemon.plist /Library/LaunchDaemons/
   sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
   sudo rm -f /Library/LaunchDaemons/org.nixos.activate-system.plist
   sudo rm -f /Library/LaunchDaemons/systems.determinate.nix-installer.nix-hook.plist
   ```

   Then remove the copied nix-darwin links in `/etc`, restoring the original
   files nix-darwin set aside. Without this, downloads fail with "error adding
   trust anchors from file: /etc/ssl/certs/ca-certificates.crt".

   ```sh
   for f in $(find /etc/ -type l -lname '/etc/static/*' 2>/dev/null); do sudo rm "$f"; [ -e "$f.before-nix-darwin" ] && sudo mv "$f.before-nix-darwin" "$f"; done
   sudo rm -f /etc/static
   sudo launchctl kickstart -k system/org.nixos.nix-daemon
   ```

5. Install Homebrew. After Migration Assistant, remove the old
   Nix-managed `/opt/homebrew` first, because it cannot work without the old
   `/nix` store. Installed apps in `/Applications` are kept and adopted.

   ```sh
   sudo rm -rf /opt/homebrew
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

6. Apply everything, then open a new terminal:

   ```sh
   ~/dotfiles/nix/scripts/update_system.sh --no-update
   ```

7. Optional one-time system settings:

   ```sh
   sudo rm -f /etc/pam.d/sudo_local
   sudo sh -c 'echo "auth       sufficient     pam_tid.so" > /etc/pam.d/sudo_local'
   sudo rm -rf "/Applications/Nix Apps"
   ```

   The first line pair enables Touch ID for `sudo`. The last line removes
   app copies left by the old nix-darwin setup.

## Moving an Existing nix-darwin Mac

Machines set up before nix-darwin was removed need a one-time change:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-darwin/nix-darwin/master#darwin-uninstaller
```

Then open a new terminal, check `nix --version` still works, and follow steps
4 to 7 of New Mac Setup. Step 4 is not needed on a machine that was not
migrated.

## Minimal Shell

Start the lightweight shell from the root flake:

```sh
nix develop
```
