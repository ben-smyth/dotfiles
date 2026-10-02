{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    git
    just
    nerd-fonts.jetbrains-mono
    neovim
    ripgrep
    tree-sitter
    wget
    zoxide
  ];
}
