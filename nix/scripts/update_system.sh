#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: update_system.sh [configuration] [--no-update] [--build-only]

Updates the root flake lock, builds the selected nix-darwin system, then
switches to it. If configuration is omitted, the script tries to infer it from
the macOS local host name.

Configurations:
  Bens-MacBook-Pro
  bens-macbook

Options:
  --no-update   Rebuild from the existing flake.lock.
  --build-only  Build the system but do not switch to it.
USAGE
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
configuration=""
update_lock=1
switch_system=1

remove_nix_result_links() {
  local link_path
  local target

  for link_path in "$repo_root"/result "$repo_root"/result-*; do
    [[ -L "$link_path" ]] || continue

    target="$(readlink "$link_path")"
    case "$target" in
      /nix/store/*)
        rm -- "$link_path"
        ;;
    esac
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-update)
      update_lock=0
      ;;
    --build-only | --no-switch)
      switch_system=0
      ;;
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

detect_configuration() {
  local host_name
  host_name="$(
    scutil --get LocalHostName 2>/dev/null ||
      hostname -s 2>/dev/null ||
      true
  )"

  case "$host_name" in
    Bens-MacBook-Pro | fluxm4p)
      printf '%s\n' "Bens-MacBook-Pro"
      ;;
    bens-macbook | bennym4p)
      printf '%s\n' "bens-macbook"
      ;;
    *)
      printf '%s\n' "$host_name"
      ;;
  esac
}

configuration="${configuration:-$(detect_configuration)}"

if [[ -z "$configuration" ]]; then
  echo "Could not infer a darwin configuration. Pass one explicitly." >&2
  exit 2
fi

cd "$repo_root"
remove_nix_result_links

if [[ "$update_lock" -eq 1 ]]; then
  nix flake update
fi

darwin-rebuild build --flake ".#${configuration}"
remove_nix_result_links

if [[ "$switch_system" -eq 1 ]]; then
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    darwin-rebuild switch --flake ".#${configuration}"
  else
    sudo darwin-rebuild switch --flake ".#${configuration}"
  fi
fi
