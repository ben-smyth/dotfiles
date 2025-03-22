#!/usr/bin/env bash
INIT=false

pull_git_changes() {
    git -C ${HOME}/installs_bs pull
}

read -p "
-- INSTALLS_BS --

[1] UBUNTU
[2] MACOS

Please Provide a Number: " -n 1 -r INSTALL_RESPONSE
echo
read -p "Full Initialization [y/N]: " -n 1 -r INIT_RESPONSE
echo
if [[ "$INIT_RESPONSE" =~ ^[Yy]$ ]]; then
    echo "Running full initialization..."
    INIT=true
fi

if [ $INIT = false ]; then
    read -p "Pull Latest Repository Changes [Y/n]: " -n 1 -r PULL_RESPONSE
    if [[ "$PULL_RESPONSE" =~ ^[Yy]$ ]]; then
        PULL_CHANGES=true
    else
        PULL_CHANGES=false
    fi
fi

if [[ $INSTALL_RESPONSE -eq 1 ]]
then
    if $INIT; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ben-smyth/installs_bs/main/ubuntu/scripts/init.sh)"
        exit
    fi
    if $PULL_CHANGES; then
        pull_git_changes
    fi
    $HOME/installs_bs/ubuntu/run.sh
fi

if [[ $INSTALL_RESPONSE -eq 2 ]]
then
    if $INIT; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ben-smyth/installs_bs/main/macos/scripts/init.sh)"
        exit
    fi
    if $PULL_CHANGES; then
        pull_git_changes
    fi
    $HOME/installs_bs/macos/run.sh
fi
