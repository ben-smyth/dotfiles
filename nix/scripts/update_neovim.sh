#!/usr/bin/env bash
set -euo pipefail

repo_root="${DOTFILES_REPO:-$HOME/dotfiles}"
nvim_config="$repo_root/dotfiles/.config/nvim"

cd "$nvim_config"
nvim --headless "+Lazy! sync" +qa
nvim --headless "+Lazy! build nvim-treesitter" +qa
