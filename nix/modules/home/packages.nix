{ pkgs, ... }:
{
  # Command-line tools shared by every machine. Mac GUI apps belong in
  # homebrew/Brewfile; project-specific tools belong in a project dev shell.
  home.packages = with pkgs; [
    alacritty
    argocd
    bash
    cargo
    d2
    delta
    docker
    eza
    fd
    fzf
    gh
    git
    go
    htop
    just
    k9s
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    nerd-fonts.jetbrains-mono
    neovim
    nmap
    nodejs
    pre-commit
    python3
    ripgrep
    stow
    tflint
    tldr
    tmux
    tree-sitter
    vim
    wget
    zoxide
  ];
}
