{
  self,
  username,
  homeDirectory,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.primaryUser = username;
  system.stateVersion = 6;

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh = {
    enableCompletion = false;
    promptInit = "";
  };

  users.users.${username} = {
    name = username;
    home = homeDirectory;
  };
}
