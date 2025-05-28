{ config, pkgs, lib, ... }:
let
in
{
  nixpkgs.config.allowUnfree = true;

  programs = {
    vscode = {
      enable = true;
      userSettings = {
        "editor.fontSize" = 14;
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "terminal.integrated.fontSize" = 13;
        "workbench.colorTheme" = "Default Dark+";
        "extensions.autoUpdate" = true;
      };
    };
  };
  home = {
    username = "bensmyth";
    homeDirectory = "/Users/bensmyth";
    stateVersion = "24.05";

    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [
      neovim
      git
      fzf
      ripgrep
      wget
      zoxide
      nerd-fonts.jetbrains-mono
      home-manager
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
    file = {
      ".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink
           "${config.home.homeDirectory}/dotfiles/dotfiles/.config/nvim";
      };
      ".config/alacritty.toml" = {
        source = ../../../dotfiles/.config/alacritty.toml;
      };
      ".zshrc" = {
        source = ../../../dotfiles/.zshrc;
      };
      ".p10k.zsh" = {
        source = ../../../dotfiles/.p10k.zsh;
      };
      ".ben_scripts.sh" = {
        source = ../../../dotfiles/.ben_scripts.sh;
      };
    };
  };
  imports = [
    ../../config/default.nix
  ];

}
