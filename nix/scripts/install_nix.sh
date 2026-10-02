#!/usr/bin/env bash
# Install upstream multi-user Nix. nix-darwin manages the Nix daemon and
# /etc/nix/nix.conf in this flake (nix.settings in base.nix), which is not
# compatible with Determinate Nix unless nix.enable = false.
curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install | sh -s -- --daemon
