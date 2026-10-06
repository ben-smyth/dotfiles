{ ... }:
{
  imports = [
    ../../config/default.nix
    ./files.nix
    ./homebrew.nix
    ./launchd.nix
    ./macos.nix
    ./packages.nix
    ./vscode.nix
  ];

  programs.home-manager.enable = true;
}
