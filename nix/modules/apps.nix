{
  inputs = {
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { nix-darwin, mac-app-util, ... }: {
    darwinConfigurations = {
      MyHost = nix-darwin.lib.darwinSystem {
        modules = [
          mac-app-util.darwinModules.default
        ];
      };
    };
  };
}
