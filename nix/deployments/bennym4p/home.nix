{ config, pkgs, ... }:
{
	imports = [
		../../config/default.nix
	];

	home.homeDirectory = "/Users/admin";
	home.stateVersion = "24.05";
	programs.home-manager.enable = true;

	home.packages = [
		pkgs.neovim
		pkgs.git
		pkgs.fzf
		pkgs.ripgrep
		pkgs.wget
		pkgs.zoxide
		pkgs.nerd-fonts.jetbrains-mono
	];

	home.file = {
		".config/nvim" = {
			source = ../../../dotfiles/.config/nvim;
			recursive = true;
		};
	};
	home.file = {
		".config/alacritty.toml" = {
			source = ../../../dotfiles/.config/alacritty.toml;
		};
	};

	home.file = {
		".zshrc" = {
			source = ../../../dotfiles/.zshrc;
		};
	};
	home.file = {
		".p10k.zsh" = {
			source = ../../../dotfiles/.p10k.zsh;
		};
	};

	programs.vscode = {
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

	home.sessionVariables = {
		EDITOR = "nvim";
	};

}
