{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    cargo
    docker
    fzf
    git
    go
    google-chrome
    htop
    k9s
    kubectl
    kubectx
    kustomize
    neovim
    nodejs
    obsidian
    python3
    ripgrep
    spotify
    stow
    tmux
    vim
    vscode
  ];
}
