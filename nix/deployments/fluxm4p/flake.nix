{ 
  description = "Ben's MacOS Flake"; 
  inputs = { 
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; 
    nix-darwin.url = "github:LnL7/nix-darwin"; 
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs"; 
    home-manager.url = "github:nix-community/home-manager/release-24.05"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; 
    mac-app-util.url = "github:hraban/mac-app-util"; 
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; }; 
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; }; 
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    mac-app-util,
    nix-homebrew,
    home-manager,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    ...
    }: let
      configuration = {
        pkgs,
        config,
        ...
        }: {
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [
            pkgs.vim
            pkgs.go
            pkgs.python3Full
            pkgs.pipx
            pkgs.pipenv
            pkgs.awscli2
            pkgs.alacritty
            pkgs.git
            pkgs.obsidian
            pkgs.google-chrome
            pkgs.stow
            pkgs.tmux
            pkgs.opentofu
            pkgs.neovim
            pkgs.spotify
            pkgs.fzf
            pkgs.cargo
            pkgs.jre17_minimal
            pkgs.nodejs_24
            pkgs.vscode
            pkgs.ripgrep
            pkgs.k9s
            pkgs.kubectl
            pkgs.kubectx
            pkgs.kustomize
            pkgs.docker
            pkgs.htop
            pkgs.terraform
          ];

          homebrew = {
            enable = true;
            brews = [
              "mas"
            ];
            casks = [
              "docker"
              "swish"
              "sublime-text"
              "1password-cli"
              "1password"
            ];
            masApps = {
            };
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          nix.settings.experimental-features = "nix-command flakes";

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.primaryUser = "bensmyth";

          system.stateVersion = 6;

          nixpkgs.hostPlatform = "aarch64-darwin";
          security.pam.services.sudo_local.touchIdAuth = true;
          system.defaults = {
            dock.autohide = true;
            dock.show-recents = false;
            dock.magnification = false;
            dock.mineffect = "scale";
            finder.FXPreferredViewStyle = "clmv";
            # loginwindow.GuestEnabled = false;
            # NSGlobalDomain.AppleInterfaceStyle = "Dark";
            # NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
            # NSGlobalDomain.KeyRepeat = 0;
            # NSGlobalDomain.InitialKeyRepeat = 0;
            # NSGlobalDomain."com.apple.swipescrolldirection" = false;
          };
          users.users.bensmyth = {
            name = "bensmyth";
            home = "/Users/bensmyth";
          };

          system.defaults.dock.persistent-apps = [
            {"app" = "${pkgs.alacritty}/Applications/Alacritty.app";}
            {"app" = "${pkgs.obsidian}/Applications/Obsidian.app";}
            {"app" = "${pkgs.google-chrome}/Applications/Google Chrome.app";}
            {"app" = "${pkgs.spotify}/Applications/Spotify.app";}
            {"app" = "/System/Applications/Calendar.app";}
            {"app" = "/System/Applications/System Settings.app";}
          ];
        };
    in {
      darwinConfigurations."Bens-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            nix-homebrew = {
              enable = true;
              user = "bensmyth";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              mutableTaps = false;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bensmyth = import ./home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."Bens-MacBook-Pro".pkgs;
    };
}
