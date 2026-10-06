{
  description = "Ben's Home Manager config, Brewfiles, and dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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

      # One Home Manager configuration per machine, named after its user.
      # `host` selects nix/hosts/<host> and homebrew/<host>.Brewfile.
      mkHome = {
        username,
        host,
        homeDirectory ? "/Users/${username}",
        system ? "aarch64-darwin",
      }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          extraSpecialArgs = {
            inherit inputs self username homeDirectory host;
          };
          modules = [
            ./nix/modules/home
            ./nix/hosts/${host}
          ];
        };
    in
    {
      # Work MacBook Pro (fluxm4p).
      homeConfigurations.bensmyth = mkHome {
        username = "bensmyth";
        host = "fluxm4p";
      };

      # Personal MacBook (bennym4p).
      homeConfigurations.admin = mkHome {
        username = "admin";
        host = "bennym4p";
      };

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
