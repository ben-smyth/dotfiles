{ host, ... }:
let
  brewDir = ../../../homebrew;
in
{
  # Homebrew owns Mac GUI apps (casks), App Store apps, and the few formulae
  # that are not in nixpkgs. Home Manager only writes ~/.Brewfile by joining
  # the shared list with this host's list; nix/scripts/update_system.sh then
  # runs `brew bundle --global` against it.
  home.file.".Brewfile".text =
    builtins.readFile (brewDir + "/Brewfile")
    + "\n"
    + builtins.readFile (brewDir + "/${host}.Brewfile");
}
