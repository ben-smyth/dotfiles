{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    postman
  ];

  homebrew = {
    casks = [
      "ableton-live-standard@11"
      "steam"
    ];
    masApps = {
      "AdobeLightroom" = 1451544217;
      "NordVPN" = 905953485;
      "WhatsApp" = 310633997;
    };
  };

  system.defaults = {
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
    NSGlobalDomain.KeyRepeat = 0;
    NSGlobalDomain.InitialKeyRepeat = 0;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
  };

  system.defaults.dock.persistent-apps = [
    { app = "${pkgs.alacritty}/Applications/Alacritty.app"; }
    { app = "${pkgs.obsidian}/Applications/Obsidian.app"; }
    { app = "${pkgs.google-chrome}/Applications/Google Chrome.app"; }
    { app = "${pkgs.spotify}/Applications/Spotify.app"; }
    { app = "/Applications/WhatsApp.app"; }
    { app = "/System/Applications/Calendar.app"; }
    { app = "/System/Applications/System Settings.app"; }
  ];
}
