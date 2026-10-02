{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    arping
    awscli2
    jre17_minimal
    opentofu
    pipenv
    pipx
    python3Packages.pip
    terraform
  ];

  homebrew = {
    brews = [
      "argocd"
      "arp-scan"
      "d2"
      "gh"
      "helm"
      "nmap"
      "openjdk"
      "pre-commit"
      "sshpass"
      "tflint"
    ];
    casks = [
      "1password"
      "1password-cli"
      "docker"
      "openwebstart"
      "xquartz"
    ];
  };

  system.defaults.dock.persistent-apps = [
    { app = "${pkgs.alacritty}/Applications/Alacritty.app"; }
    { app = "${pkgs.obsidian}/Applications/Obsidian.app"; }
    { app = "${pkgs.google-chrome}/Applications/Google Chrome.app"; }
    { app = "${pkgs.spotify}/Applications/Spotify.app"; }
    { app = "/System/Applications/Calendar.app"; }
    { app = "/System/Applications/System Settings.app"; }
  ];
}
