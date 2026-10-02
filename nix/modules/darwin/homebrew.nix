{
  inputs,
  username,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    user = username;
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "fd"
      "git-delta"
      "eza"
      "tldr"
    ];
    casks = [
      "sublime-text"
      "jordanbaird-ice"
      "swish"
      "1password"
      "1password-cli"
      "docker"
    ];
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
