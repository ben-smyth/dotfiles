#!/usr/bin/env bash
set -euo pipefail

export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

usage() {
  cat <<'USAGE'
Usage: update_home.sh [home-configuration]

Applies only the Home Manager configuration from the root flake. This updates
user-level files, packages, and symlinks without running nix-darwin activation.

Configurations:
  bensmyth
  admin
USAGE
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
configuration=""

while [[ $# -gt 0 ]]; do
  case "$1" in
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

configuration="${configuration:-${USER:-${LOGNAME:-}}}"

if [[ -z "$configuration" ]]; then
  configuration="$(/usr/bin/id -un)"
fi

case "$configuration" in
  bensmyth | admin)
    ;;
  *)
    echo "Unknown Home Manager configuration: $configuration" >&2
    usage >&2
    exit 2
    ;;
esac

cd "$repo_root"
nix run ".#home-manager" -- switch --flake ".#${configuration}"
