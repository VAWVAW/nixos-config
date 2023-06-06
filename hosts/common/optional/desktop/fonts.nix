{ pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [ corefonts font-awesome ];
    enableDefaultFonts = true;
  };
}
