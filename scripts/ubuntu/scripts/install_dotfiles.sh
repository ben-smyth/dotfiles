#!/usr/bin/env bash
set -euo pipefail

prepare_tmux() {
    tmux start-server

    # create a new session but don't attach to it either
    tmux new-session -d

    # install the plugins
    TMUX_PLUGIN_MANAGER_PATH=${HOME}/.tmux/plugins/ ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh

    # killing the server is not required, I guess
    tmux kill-server
}

echo "[DOT] Installing dotfiles"

echo "[DOT] Checking for STOW install..."

if !(stow -V); then
    echo "[DOT] STOW not installed, exiting..."
    exit 1
fi

echo "[DOT] STOW install found..."
# DELETE STOW MAPPING: stow --dir dotfiles/ -D .

if stow --adopt --dir $HOME/installs_bs/dotfiles --target $HOME/. .; then
    echo "[DOT] STOW links added"
else
    echo "[DOT] STOW links failed. Exiting."
    exit 1
fi


# echo "[DOT] Installing TMUX TPM plugins..."
# if ! prepare_tmux; then
#     echo "[DOT] Preparing TMUX failed. Be ready to manually install plugins. LEADER+I"
# fi

exec /usr/bin/env zsh
