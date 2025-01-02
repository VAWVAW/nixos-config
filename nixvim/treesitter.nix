{ config, lib, ... }: {
  plugins = lib.mkMerge [
    { treesitter.enable = lib.mkDefault true; }
    (lib.mkIf config.plugins.treesitter.enable {
      rainbow-delimiters.enable = true;
      nvim-autopairs.enable = true;
      treesitter-context.enable = true;

      illuminate = {
        enable = true;
        minCountToHighlight = 2;
      };

      treesitter = {
        gccPackage = null;
        nodejsPackage = null;
        treesitterPackage = null;

        folding = true;
        settings.indent.enable = true;
        settings.highlight.enable = true;
      };

    })
  ];
}
