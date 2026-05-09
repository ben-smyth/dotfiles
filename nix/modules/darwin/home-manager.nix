{
  inputs,
  username,
  homeDirectory,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs username homeDirectory;
    };
    users.${username}.imports = [
      ../home
    ];
  };
}
