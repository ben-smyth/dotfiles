{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    git
    nerd-fonts.jetbrains-mono
    neovim
    ripgrep
    wget
    zoxide
  ];
}
