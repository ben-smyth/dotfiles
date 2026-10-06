#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: update_system.sh [configuration] [--no-update] [--build-only]

Applies the Home Manager configuration (CLI tools, dotfiles, macOS user
settings), then installs the Homebrew packages listed in ~/.Brewfile and
reports anything Homebrew has installed that the Brewfile does not list.

Configurations (default: current user):
  bensmyth   work MacBook Pro (fluxm4p)
  admin      personal MacBook (bennym4p)

Options:
  --no-update   Keep flake.lock and skip Homebrew's auto-update.
  --build-only  Build the Home Manager configuration without applying it.
USAGE
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
configuration=""
update_lock=1
switch_system=1

# Flakes may not be enabled yet on a fresh machine; Home Manager enables them
# in ~/.config/nix/nix.conf after the first switch.
export NIX_CONFIG="experimental-features = nix-command flakes${NIX_CONFIG:+
$NIX_CONFIG}"

remove_nix_result_links() {
  local link_path
  for link_path in "$repo_root"/result "$repo_root"/result-*; do
    [[ -L "$link_path" ]] || continue
    case "$(readlink "$link_path")" in
      /nix/store/*) rm -- "$link_path" ;;
    esac
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-update) update_lock=0 ;;
    --build-only | --no-switch) switch_system=0 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      if [[ -n "$configuration" ]]; then
        usage >&2
        exit 2
      fi
      configuration="$1"
      ;;
  esac
  shift
done

configuration="${configuration:-${USER:-$(/usr/bin/id -un)}}"

case "$configuration" in
  bensmyth | admin) ;;
  *)
    echo "Unknown configuration: $configuration" >&2
    usage >&2
    exit 2
    ;;
esac

cd "$repo_root"
remove_nix_result_links

if [[ "$update_lock" -eq 1 ]]; then
  nix flake update
fi

if [[ "$switch_system" -eq 0 ]]; then
  nix run ".#home-manager" -- build --flake ".#${configuration}"
  remove_nix_result_links
  exit 0
fi

nix run ".#home-manager" -- switch -b hm-backup --flake ".#${configuration}"

brew_bin=""
for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$candidate" ]]; then
    brew_bin="$candidate"
    break
  fi
done

if [[ -z "$brew_bin" ]]; then
  echo "Homebrew is not installed; skipping ~/.Brewfile. Install it from https://brew.sh and rerun." >&2
  exit 0
fi

if [[ "$update_lock" -eq 0 ]]; then
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

"$brew_bin" bundle install --global

echo
echo "Checking for Homebrew packages not listed in the Brewfiles..."
if ! "$brew_bin" bundle cleanup --global; then
  echo "Add them to homebrew/*.Brewfile (or nixpkgs), or remove them with:" >&2
  echo "  brew bundle cleanup --global --force" >&2
fi
