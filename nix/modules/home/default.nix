{ ... }:
{
  imports = [
    ../../config/default.nix
    ./files.nix
    ./launchd.nix
    ./packages.nix
    ./vscode.nix
  ];

  programs.home-manager.enable = true;
}
