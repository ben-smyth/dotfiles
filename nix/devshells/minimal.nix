{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    cargo
    fzf
    git
    go
    neovim
    nodejs
    opentofu
    python3
    ripgrep
    tree-sitter
    tmux
    vim
  ];

  shellHook = ''
    echo "Welcome to Ben's Minimal Shell!"
  '';
}
