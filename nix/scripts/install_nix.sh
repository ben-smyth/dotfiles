#!/usr/bin/env bash
# Install upstream multi-user Nix. Answer yes to the prompts, then open a new
# terminal before running nix/scripts/update_system.sh.
curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install | sh -s -- --daemon
