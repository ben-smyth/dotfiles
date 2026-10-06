{ pkgs, ... }:
{
  # Work MacBook Pro. Casks and other Homebrew items: homebrew/fluxm4p.Brewfile.
  home.packages = with pkgs; [
    arp-scan
    arping
    awscli2
    jre17_minimal
    opentofu
    pipenv
    pipx
    python3Packages.pip
    sshpass
    terraform
  ];
}
