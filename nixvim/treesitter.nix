{ lib, ... }: {
  plugins = {
    rainbow-delimiters.enable = true;
    nvim-autopairs.enable = true;

    illuminate = {
      enable = true;
      minCountToHighlight = 2;
    };

    treesitter = {
      enable = lib.mkDefault true;

      gccPackage = null;
      nodejsPackage = null;
      treesitterPackage = null;

      folding = true;
      settings.indent.enable = true;
      settings.highlight.enable = true;
    };
  };
}
