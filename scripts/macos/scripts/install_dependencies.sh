#!/usr/bin/env bash

set -euo pipefail

# 1. install brew
/usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# 2. install using brewfile



install_nerdfont() {
    wget -P ~/Library/Fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
    && cd ~/Library/Fonts \
    && unzip -n JetBrainsMono.zip \
    && rm JetBrainsMono.zip \
    && fc-cache -fv
}