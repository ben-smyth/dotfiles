{ lib, ... }:
{
  system.activationScripts.preActivation.text = lib.mkBefore ''
    # nix-darwin 26.05 checks app-management permissions before migrating
    # this old symlink, so remove only the symlink shape it owns first.
    nixAppsPath='/Applications/Nix Apps'

    nixDarwinAppLink() {
      local link
      link=$(readlink "$1" 2>/dev/null || true)
      [ -L "$1" ] && [ "''${link#*-}" = 'system-applications/Applications' ]
    }

    if nixDarwinAppLink "$nixAppsPath"; then
      rm "$nixAppsPath"
    fi
  '';
}
