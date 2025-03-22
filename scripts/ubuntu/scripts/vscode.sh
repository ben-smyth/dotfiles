#!/usr/bin/env bash

set -euo pipefail

FREEZE_LIST=${HOME}/installs_bs/dotfiles/.vscode_freeze.txt

if (code --version); then
    echo "VSCode CLI installation detected, continuing..."
else
    echo "VSCode CLI not installed... please install before continuing."
    exit 1
fi

read -p "
-- VSCODE PLUGIN ORCHESTRATION --

[1] FREEZE PLUGINS
[2] INSTALL PLUGINS

Please Provide a Number: " -n 1 -r VSCODE_RESPONSE
echo

if [[ $VSCODE_RESPONSE -eq 1 ]]; then
    echo "Freezing VSCode plugins to ${FREEZE_LIST}"
    code --list-extensions > ${FREEZE_LIST}
    cat $FREEZE_LIST
    exit $?
fi

if [[ $VSCODE_RESPONSE -eq 2 ]]; then
    echo "Installing plugin from list ${FREEZE_LIST}"
    cat $FREEZE_LIST
    echo
    cat extensions.txt | xargs -L 1 code --install-extension
    exit $?
fi


