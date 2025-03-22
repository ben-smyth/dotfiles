#!/usr/bin/env bash
#
# Init script for ubuntu host without any pre-installed software.
#

set -euo pipefail


# set basic git settings for clone
install_and_configure_git() {
    sudo apt-get install git -y
    git config --global user.email "ben.df.smyth@gmail.com"
    git config --global user.name "ben-smyth"
}

# check for ssh key - create if doesn't exist
setup_ssh() {
    SSH_DIR="$HOME/.ssh"

    declare -A KEY_TYPES
    KEY_TYPES=(
        ["rsa"]="id_rsa"
        ["dsa"]="id_dsa"
        ["ecdsa"]="id_ecdsa"
        ["ed25519"]="id_ed25519"
    )

    existing_keys=$(find "$SSH_DIR" -type f \( -name "id_rsa*" -o -name "id_dsa*" -o -name "id_ecdsa*" -o -name "id_ed25519*" \))

    if [ -n "$existing_keys" ]; then
        echo "[INIT] Existing SSH keys found:"
        echo "[INIT] $existing_keys"
    else
        echo "[INIT] No existing SSH keys found. Generating a new SSH key..."

        ssh-keygen -t "rsa" -b 4096 -f "$SSH_DIR/id_rsa" -N ""
        
        # sudo chmod 700 ~/.ssh
        # sudo chmod 600 ~/.ssh/id_rsa
        # sudo chmod 644 ~/.ssh/id_rsa.pub

        eval `ssh-agent -s`
        ssh-add
        ssh-keyscan github.com >> "$SSH_DIR/known_hosts"

        echo "[INIT] SSH key generated and added to SSH agent."
    fi
}

# clone the full repo for dotfiles and dependencies
clone_or_pull() {
    if [[ -d "${HOME}/installs_bs" ]]; then
        echo "[INIT] Pulling latest repository update..."
        git -C ~/installs_bs pull
    else
        echo "[INIT] Cloning repository fresh..."
        git clone git@github.com:ben-smyth/installs_bs.git ~/installs_bs 
    fi
}

# apt package updates and upgrades
sudo apt-get update -y
sudo apt-get upgrade -y


echo "Doing basic GIT installation and configuration..."
if ! install_and_configure_git; then
    echo "Git install and configuration failed, continuing..."
fi

eval $(cat ~/.bashrc)

echo "[INIT] Checking for SSH..."
if ! setup_ssh; then
    echo " "
    echo "[INIT] SSH configuration failed. Cannot continue."
    echo "[INIT] Please manually generate a key, then re-run the script."
    exit 1
fi

echo "Getting latest installs_bs repository..."
if ! clone_or_pull; then
    echo 
    echo "[INIT] Git repo reconciliation failed, unable to continue."
    echo
    echo "[INIT] To continue, manually reocncile https://github.com/ben-smyth/installs_bs"
    echo "[INIT] Then, run \$HOME/installs_bs/ubuntu/scripts/run.sh"
    exit 1
fi

(cd ${HOME}/installs_bs/ && ./ubuntu/run.sh --no-touch)
