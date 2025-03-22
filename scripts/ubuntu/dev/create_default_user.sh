#!/usr/bin/env bash
sudo adduser bsmyth --ingroup sudo
sudo echo "[user]
default = bsmyth" >> /etc/wsl.conf

# then wsl --terminate ubuntu
#
#
#
