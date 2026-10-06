{ ... }:
{
  # Copy Nix-provided .app bundles into ~/Applications/Home Manager Apps so
  # Spotlight and the Dock can find them (symlinked apps are not indexed).
  targets.darwin.linkApps.enable = false;
  targets.darwin.copyApps.enable = true;

  # User-level macOS settings. Some only apply after logging out and in.
  targets.darwin.defaults = {
    "com.apple.dock" = {
      autohide = true;
      show-recents = false;
      magnification = false;
      mineffect = "scale";
    };
    "com.apple.finder" = {
      FXPreferredViewStyle = "clmv";
    };
  };

  # Enable flakes for this user. The Nix installer does not enable them.
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';
}
