{ pkgs, ... }:
{
  # Personal MacBook. Casks and App Store apps: homebrew/bennym4p.Brewfile.
  home.packages = with pkgs; [
    postman
  ];

  targets.darwin.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleInterfaceStyleSwitchesAutomatically = true;
    KeyRepeat = 0;
    InitialKeyRepeat = 0;
    "com.apple.swipescrolldirection" = false;
  };
}
