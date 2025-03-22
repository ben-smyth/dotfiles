#!/usr/bin/env bash
set -euo pipefail

echo "[DOT] Checking for STOW install..."

if !(stow -V); then
    echo "[DOT] STOW not installed, exiting..."
    exit 1
fi

echo "[DOT] STOW install found..."


if stow --adopt --dir $HOME/installs_bs/dotfiles --target $HOME/. .; then
    echo "[DOT] STOW links added"
else
    echo "[DOT] STOW links failed. Exiting."
    exit 1
fi
