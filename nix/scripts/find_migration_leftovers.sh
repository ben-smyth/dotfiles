#!/bin/bash
# Read-only scan for leftovers from a Migration Assistant copy of a Mac that
# used nix-darwin / nix-homebrew. Prints what is broken and how to fix it;
# changes nothing.
#
# Usage: find_migration_leftovers.sh [--all]
#   --all  also list links that still resolve (useful on the old Mac).

show_all=0
[ "${1:-}" = "--all" ] && show_all=1

found=0
section() { printf '\n== %s ==\n' "$1"; }
hint() { printf '   fix: %s\n' "$1"; }

# Print symlinks under the given paths that point at a prefix that only
# existed on the old machine (old Nix store, nix-darwin, nix-homebrew), and are
# broken (or all of them with --all). find filters on the link text itself, so
# only candidate links are checked.
scan_links() {
  find "$@" -xdev \
    \( -name node_modules -o -name .git -o -name '*.photoslibrary' -o -name '*.pvm' \
       -o -path "$HOME/Library" -o -path "$HOME/.Trash" -o -path "$HOME/dotfiles" \
       -o -path "$HOME/go/pkg" -o -path "$HOME/.npm" -o -path "$HOME/.local/state/nix" \
       -o -path "$HOME/.cache/nix" -o -path "$HOME/.codex/.tmp" -o -path "$HOME/Pictures" \
       -o -path "$HOME/Movies" -o -path "$HOME/Music" -o -path "$HOME/Parallels" \
       -o -path /etc/static \) -prune \
    -o -type l \( -lname '/nix/store/*' -o -lname '/etc/static/*' -o -lname '/etc/profiles/*' \
                  -o -lname '/opt/homebrew/*' -o -lname '/run/current-system/*' \) -print 2>/dev/null |
  while IFS= read -r link; do
    if [ "$show_all" -eq 1 ] || [ ! -e "$link" ]; then
      printf '%s -> %s\n' "$link" "$(readlink "$link")"
    fi
  done
}

echo "Scanning (this takes a minute or two)..."
home_links="$(scan_links "$HOME")"
py_pattern='/bin/python[0-9.]* -> '

section "Broken Python environments (interpreter came from old Nix or Homebrew)"
py="$(printf '%s\n' "$home_links" | grep -E "$py_pattern")"
if [ -n "$py" ]; then
  found=1
  printf '%s\n' "$py" | sed 's/^/   /'
  printf '%s\n' "$py" | grep -q '/.local/pipx/' && hint "pipx reinstall-all"
  printf '%s\n' "$py" | grep -q '/pre-commit' && hint "pre-commit clean   (caches rebuild on next run)"
  printf '%s\n' "$py" | grep -q '/.local/share/virtualenvs/' && hint "in each project: pipenv --rm && pipenv install"
  printf '%s\n' "$py" | grep -q '/nvim/mason/' && hint "in nvim: :MasonUninstall <package>, then :MasonInstall <package>"
  printf '%s\n' "$py" | grep -v -E '/.local/pipx/|/pre-commit|/.local/share/virtualenvs/|/nvim/mason/' | grep -q . &&
    hint "delete and recreate the listed .venv folders (python3 -m venv .venv)"
else
  echo "   none"
fi

section "Other broken links in your home folder"
other="$(printf '%s\n' "$home_links" | grep -v -E "$py_pattern" | grep .)"
if [ -n "$other" ]; then
  found=1
  printf '%s\n' "$other" | sed 's/^/   /'
  hint "links Home Manager still manages are replaced by update_system.sh;"
  hint "remove any that remain afterwards with: rm '<path>'"
else
  echo "   none"
fi

section "Broken links in /etc, /usr/local and /Applications"
sys="$(scan_links /etc/ /usr/local /Applications)"
if [ -n "$sys" ]; then
  found=1
  printf '%s\n' "$sys" | sed 's/^/   /'
  hint "README step 4 (/etc links); otherwise sudo rm '<path>'"
else
  echo "   none"
fi
[ -e /etc/static ] || [ ! -L /etc/static ] || {
  found=1
  echo "   /etc/static -> $(readlink /etc/static)"
  hint "sudo rm /etc/static"
}

section "Old nix-darwin app copies"
if [ -d "/Applications/Nix Apps" ]; then
  found=1
  echo "   /Applications/Nix Apps"
  hint "sudo rm -rf '/Applications/Nix Apps'"
else
  echo "   none"
fi

section "Launch jobs that run programs that no longer exist"
jobs_found=0
for plist in /Library/LaunchDaemons/*.plist /Library/LaunchAgents/*.plist "$HOME"/Library/LaunchAgents/*.plist; do
  [ -f "$plist" ] || continue
  label="$(basename "$plist" .plist)"
  case "$label" in
    org.nixos.activate-system | systems.determinate.nix-installer.nix-hook)
      jobs_found=1
      echo "   $plist (nix-darwin/Determinate leftover)"
      continue
      ;;
  esac
  for p in $(grep -o '/nix/store/[^<"& ]*' "$plist" 2>/dev/null | sort -u); do
    if [ ! -e "$p" ] || [ "$show_all" -eq 1 ]; then
      jobs_found=1
      echo "   $plist -> $p"
    fi
  done
done
if [ "$jobs_found" -eq 1 ]; then
  found=1
  hint "nix-daemon: README step 4; others: sudo launchctl bootout system/<label>; sudo rm <plist>"
else
  echo "   none"
fi

section "Nix store volume in /etc/fstab"
if mount | grep -q ' on /nix '; then
  vol_uuid="$(/usr/sbin/diskutil info /nix 2>/dev/null | awk -F': *' '/Volume UUID/ {print $2}')"
  fstab_lines="$(grep -E '[[:space:]]/nix[[:space:]]' /etc/fstab 2>/dev/null)"
  printf '   mounted volume UUID: %s\n' "${vol_uuid:-unknown}"
  printf '%s\n' "${fstab_lines:-   (no /nix line in /etc/fstab)}" | sed 's/^/   fstab: /'
  if [ -n "$vol_uuid" ] && ! printf '%s\n' "$fstab_lines" | grep -qi "UUID=$vol_uuid"; then
    found=1
    hint "fstab does not match the mounted Nix volume; it will mount with the wrong"
    hint "options after a reboot. Edit with: sudo vifs   (set UUID=$vol_uuid on the /nix line,"
    hint "and delete any other /nix lines)"
  elif [ "$(printf '%s\n' "$fstab_lines" | grep -c .)" -gt 1 ]; then
    found=1
    hint "more than one /nix line; keep only UUID=$vol_uuid (sudo vifs)"
  else
    echo "   ok"
  fi
else
  found=1
  echo "   /nix is not mounted"
fi

echo
if [ "$found" -eq 0 ]; then
  echo "No migration leftovers found."
else
  echo "Review the items above. This script did not change anything."
fi
