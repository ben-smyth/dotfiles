{
  description = "Ben's Darwin systems, Home Manager config, and dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    catppuccin-tmux = {
      url = "github:dreamsofcode-io/catppuccin-tmux";
      flake = false;
    };
    tokyo-night-tmux = {
      url = "github:janoamaral/tokyo-night-tmux";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    ...
  }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgsFor = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkDarwin = {
        username,
        hostModule,
        homeDirectory ? "/Users/${username}",
        system ? "aarch64-darwin",
      }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs self username homeDirectory;
          };
          modules = [
            inputs.nix-homebrew.darwinModules.nix-homebrew
            inputs.home-manager.darwinModules.home-manager
            ./nix/modules/darwin
            hostModule
          ];
        };

      mkHome = {
        username,
        homeDirectory ? "/Users/${username}",
        system ? "aarch64-darwin",
      }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          extraSpecialArgs = {
            inherit inputs self username homeDirectory;
          };
          modules = [
            ./nix/modules/home
          ];
        };
    in
    {
      darwinConfigurations."Bens-MacBook-Pro" = mkDarwin {
        username = "bensmyth";
        homeDirectory = "/Users/bensmyth";
        hostModule = ./nix/hosts/fluxm4p;
      };

      darwinConfigurations."bens-macbook" = mkDarwin {
        username = "admin";
        homeDirectory = "/Users/admin";
        hostModule = ./nix/hosts/bennym4p;
      };

      homeConfigurations.bensmyth = mkHome {
        username = "bensmyth";
        homeDirectory = "/Users/bensmyth";
      };

      homeConfigurations.admin = mkHome {
        username = "admin";
        homeDirectory = "/Users/admin";
      };

      darwinPackages = self.darwinConfigurations."Bens-MacBook-Pro".pkgs;

      packages = forAllSystems (system: {
        home-manager = inputs.home-manager.packages.${system}.home-manager;
      });

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          minimal = import ./nix/devshells/minimal.nix { inherit pkgs; };
        in
        {
          default = minimal;
          minimal = minimal;
        });
    };
}
