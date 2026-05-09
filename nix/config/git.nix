{ config, pkgs, ... }:
{
  programs.git = { 
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "ben-smyth";
        email = "ben.df.smyth@gmail.com";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
