{ ... }:
{
  imports = [
    ../../config/default.nix
    ./files.nix
    ./packages.nix
    ./vscode.nix
  ];

  programs.home-manager.enable = true;
}
