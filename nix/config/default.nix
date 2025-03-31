{ config, pkgs, ... }:
{
  programs.git = import ./git.nix;
  programs.tmux = import ./tmux.nix;
}
