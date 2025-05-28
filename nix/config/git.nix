{ config, pkgs, ... }:
{
  programs.git = { 
    enable = true;
    lfs.enable = true;
    userName = "ben-smyth";
    userEmail = "ben.df.smyth@gmail.com";

    extraConfig = {
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
