{ config, pkgs, ... }:
{
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
			source = ../dotfiles/.config/nvim;
			recursive = true;
		};
	};
	home.file = {
		".config/alacritty.toml" = {
			source = ../dotfiles/.config/alacritty.toml;
		};
	};
	home.sessionVariables = {
		EDITOR = "nvim";
	};
}
