{
  description = "Ben's Minimal-Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew?ref=refs/pull/71/merge";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-homebrew,
    home-manager,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    ...
    }: let
      configuration = {
        pkgs,
        config,
        ...
        }: {
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [
            pkgs.vim
            pkgs.go
            pkgs.python3Full
            pkgs.git
            pkgs.tmux
            pkgs.neovim
            pkgs.fzf
            pkgs.cargo
            pkgs.nodejs_23
            pkgs.ripgrep
          ];

          homebrew = {
            enable = true;
            brews = [
            ];
            casks = [
            ];
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          nix.settings.experimental-features = "nix-command flakes";

        };
    in {
    };
}
