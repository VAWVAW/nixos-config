{
  plugins = {
    rainbow-delimiters.enable = true;
    nvim-autopairs.enable = true;

    illuminate = {
      enable = true;
      minCountToHighlight = 2;
    };

    treesitter = {
      enable = true;

      gccPackage = null;
      # nodejsPackage = null;
      # treesitterPackage = null;

      folding = true;
      indent = true;
    };
  };
}
