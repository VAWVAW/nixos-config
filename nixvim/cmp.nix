{ helpers, ... }: {
  plugins.cmp = {
    enable = true;
    filetype = rec {
      "tex".sources = [{
        name = "latex_symbols";
        option.strategy = 2;
      }];
      "latex" = tex;
      "markdown" = tex;
    };

    settings = {
      autoEnableSources = true;

      snippet.expand = "luasnip";
      window.documentation = helpers.mkRaw "cmp.config.window.bordered()";

      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        {
          name = "buffer";
          option.get_bufnrs = helpers.mkRaw "vim.api.nvim_list_bufs";
        }
      ];

      formatting = {
        fields = [ "kind" "abbr" "menu" ];
        format = let
          kind_icons = {
            Text = "";
            Method = "M";
            Function = "󰊕";
            Constructor = "";
            Field = "";
            Variable = "";
            Class = "";
            Interface = "";
            Module = "";
            Property = "";
            Unit = "";
            Value = "";
            Enum = "";
            Keyword = "󰌆";
            Snippet = "";
            Color = "";
            File = "";
            Reference = "";
            Folder = "";
            EnumMember = "";
            Constant = "󰈚";
            Struct = "󰅩";
            Event = "";
            Operator = "󱓉";
            TypeParameter = "T";
          };
        in ''
          function(entry, vim_item)
            local kind_icons = ${helpers.toLuaObject kind_icons}
            vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              buffer = '[Buffer]',
              path = '[Path]',
              dap = '[DAP]',
            })[entry.source.name]
            return vim_item
          end'';
      };

      mapping = {
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<CR>" = "cmp.mapping.confirm { select = true }";
        "<Tab>" = "cmp.mapping.select_next_item()";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";
      };
    };
  };
}
