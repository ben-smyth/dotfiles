#!/usr/bin/env bash
set -euo pipefail

echo 'script to remove WSL user and create a new one'

deluser() {
    sudo userdel --force --remove bentest
    if [[ $? -eq 0 ]]; then
        echo 'User bentest removed'
    else
        echo 'User bentest not removed'
    fi
}

if ! deluser; then 
    echo "failed to delete user, continuing..."
fi

sudo adduser bentest --ingroup sudo