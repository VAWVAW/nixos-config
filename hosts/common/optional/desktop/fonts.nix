{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [ corefonts font-awesome ];
    enableDefaultPackages = true;
  };
}
