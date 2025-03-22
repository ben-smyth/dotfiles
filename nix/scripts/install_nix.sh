#!/usr/bin/env bash
# Select [n] in order to install the recommended version
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
