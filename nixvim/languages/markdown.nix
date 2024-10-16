{ config, pkgs, lib, helpers, ... }: {
  options.languages.markdown.enable =
    lib.mkEnableOption "markdown file support";

  config = lib.mkIf config.languages.markdown.enable {
    extraPlugins = [ pkgs.vimPlugins.nabla-nvim ];

    autoCmd = [{
      event = "FileType";
      pattern = "markdown";
      callback = helpers.mkRaw ''
        function()
          vim.api.nvim_create_autocmd("BufWrite", {
            buffer = 0,
            callback = require("nabla").enable_virt
          })
          require("nabla").enable_virt()
        end'';
    }];
  };
}
