{
  config,
  homeDirectory,
  username,
  ...
}:
let
  repoDir = "${homeDirectory}/dotfiles";
  agentsDir = "${repoDir}/.agents";
  dotfilesDir = "${repoDir}/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
    enableNixpkgsReleaseCheck = false;

    file = {
      ".ben_scripts.sh".source = link "${dotfilesDir}/.ben_scripts.sh";
      ".cheats.txt".source = link "${dotfilesDir}/.cheats.txt";
      ".claude/CLAUDE.md".source = link "${agentsDir}/AGENTS.md";
      ".claude/settings.json" = {
        source = link "${agentsDir}/claude/settings.json";
        force = true;
      };
      ".codex/AGENTS.md".source = link "${agentsDir}/AGENTS.md";
      ".codex/alerts.config.toml".source = link "${agentsDir}/codex/alerts.config.toml";
      ".config/alacritty.toml".source = link "${dotfilesDir}/.config/alacritty.toml";
      ".config/k9s".source = link "${dotfilesDir}/.config/k9s";
      ".config/nvim".source = link "${dotfilesDir}/.config/nvim";
      ".p10k.zsh".source = link "${dotfilesDir}/.p10k.zsh";
      ".zshrc".source = link "${dotfilesDir}/.zshrc";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
