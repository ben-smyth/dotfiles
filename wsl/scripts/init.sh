#!/usr/bin/env bash
#
# Init script for WSL host without any pre-installed software.
#

set -euo pipefail


# # set basic git settings for clone
# configure_git() {
#     git config --global user.email "ben.df.smyth@gmail.com"
#     git config --global user.name "ben-smyth"
# }

# check for ssh key - create if doesn't exist
setup_ssh() {
    # Define the SSH directory
    SSH_DIR="$HOME/.ssh"

    # Define supported key types and their default filenames
    declare -A KEY_TYPES
    KEY_TYPES=(
        ["rsa"]="id_rsa"
        ["dsa"]="id_dsa"
        ["ecdsa"]="id_ecdsa"
        ["ed25519"]="id_ed25519"
    )

    # Check for existing SSH keys
    existing_keys=$(find "$SSH_DIR" -type f \( -name "id_rsa*" -o -name "id_dsa*" -o -name "id_ecdsa*" -o -name "id_ed25519*" \))

    if [ -n "$existing_keys" ]; then
        echo "Existing SSH keys found:"
        echo "$existing_keys"
    else
        echo "No existing SSH keys found. Generating a new SSH key..."

        mkdir -p $SSH_DIR

        key_file="id_rsa"
        ssh-keygen -t "rsa" -b 4096 -f "$SSH_DIR/$key_file" -N ""
        
        sudo chmod 700 ~/.ssh
        sudo chmod 600 ~/.ssh/id_rsa
        sudo chmod 644 ~/.ssh/id_rsa.pub

        # Start the SSH agent and add the new key
        eval `ssh-agent`
        ssh-add
        ssh-keyscan github.com >> "$SSH_DIR/known_hosts"

        echo "SSH key generated and added to SSH agent."
    fi
}

# clone the full repo for dotfiles and dependencies
clone_or_pull() {
    if [[ -d "${HOME}/installs_bs" ]]; then
        echo "Pulling latest repository update..."
        git -C ~/installs_bs pull
    else
        echo "Cloning repository fresh..."
        git clone git@github.com:ben-smyth/installs_bs.git ~/installs_bs 
    fi
}

# apt package updates and upgrades
sudo apt-get update -y
sudo apt-get upgrade -y


# echo "Doing basic GIT configuration..."
# if ! configure_git; then
#     echo "Git configuration failed, continuing..."
# fi

eval $(cat ~/.bashrc)

echo "Checking for SSH..."
if ! setup_ssh; then
    echo " "
    echo "SSH configuration failed. Cannot continue."
    echo "Please manually generate a key, then re-run the script."
    exit 1
fi

echo "Getting latest installs_bs repository..."
if ! clone_or_pull; then
    echo " "
    echo "Git repo reconciliation failed, unable to continue."
    echo " "
    echo "To continue, manually reocncile https://github.com/ben-smyth/installs_bs"
    echo "Then, run \$HOME/installs_bs/wsl/scripts/run.sh"
    exit 1
fi

(cd ${HOME}/installs_bs/ && ./wsl/run.sh --no-touch)