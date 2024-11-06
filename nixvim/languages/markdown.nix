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
          local nabla = require("nabla")
          vim.api.nvim_create_autocmd("BufWrite", {
            buffer = 0,
            callback = function()
              nabla.enable_virt()
              vim.o.wrap = true
            end
          })
          vim.keymap.set("n", "<leader>k", nabla.popup, {noremap=true, silent=true})
          vim.keymap.set("n", "<leader>o", ":silent !pandoc '%' -o /tmp/out.pdf && xdg-open /tmp/out.pdf >/dev/null<CR>", {noremap=true, silent=true})
          vim.keymap.set("i", "<C-k>", nabla.popup, {noremap=true, silent=true})
          nabla.enable_virt()
          vim.o.wrap = true
        end'';
    }];

    plugins.nvim-autopairs.luaConfig.post = ''
      require("nvim-autopairs").add_rule(require("nvim-autopairs.rule")("$", "$" , "markdown"))
    '';
  };
}
