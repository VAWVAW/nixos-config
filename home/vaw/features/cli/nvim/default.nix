{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [ wl-clipboard jq taplo shellcheck ];

  imports = [ ./lsp.nix ];

  programs.neovim = let
    formatLuaFileName =
      builtins.replaceStrings [ "/nix/store/" ".lua" ] [ "" "" ];
  in {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set clipboard+=unnamed
      set fileencoding=utf-8
      set nobackup
      set undofile
      set updatetime=1000
      set mouse=

      set hlsearch
      set ignorecase
      set smartcase

      set smartindent

      set showtabline=2
      set splitbelow
      set splitright

      set foldmethod=syntax
      set foldlevelstart=99

      set expandtab
      set shiftwidth=2
      set tabstop=2

      set nowrap
      set scrolloff=4
      set sidescrolloff=8

      set number
      set relativenumber
      set signcolumn=yes

      set noshowmode
      set completeopt=menuone,noselect
      set pumheight=10
    '';
    extraLuaConfig = ''
      package.path = package.path .. ";/nix/store/?.lua"
      require "${formatLuaFileName (toString ./aerial.lua)}"
      require "${formatLuaFileName (toString ./bufferline.lua)}"
      require "${formatLuaFileName (toString ./cmp.lua)}"
      require "${formatLuaFileName (toString ./colorscheme.lua)}"
      require "${formatLuaFileName (toString ./gitsigns.lua)}"
      require "${formatLuaFileName (toString ./keybinds.lua)}"
      require "${formatLuaFileName (toString ./lsp.lua)}"
      require "${formatLuaFileName (toString ./lualine.lua)}"
      require "${formatLuaFileName (toString ./null-ls.lua)}"
      require "${formatLuaFileName (toString ./nvim-tree.lua)}"
      require "${formatLuaFileName (toString ./status-split.lua)}"
      require "${formatLuaFileName (toString ./symbols-outline.lua)}"
      require "${formatLuaFileName (toString ./telescope.lua)}"
      require "${formatLuaFileName (toString ./toggleterm.lua)}"
      require "${formatLuaFileName (toString ./treesitter.lua)}"
    '';
    extraPackages = with pkgs; [ ripgrep ];
    plugins = with pkgs.vimPlugins; [
      # misc
      plenary-nvim
      comment-nvim
      toggleterm-nvim
      symbols-outline-nvim
      undotree

      # git
      gitsigns-nvim
      vim-fugitive

      # nvim-tree
      nvim-web-devicons
      nvim-tree-lua
      project-nvim

      # lualine
      lualine-nvim
      lualine-lsp-progress

      # telescope
      telescope-nvim
      telescope-ui-select-nvim
      telescope-symbols-nvim

      # completion
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp_luasnip
      cmp-nvim-lsp

      # snippets
      luasnip
      friendly-snippets

      # lsp
      nvim-lspconfig
      nvim-dap
      nvim-dap-ui
      nvim-dap-python
      null-ls-nvim
      aerial-nvim
      rust-tools-nvim
      nvim-metals

      # treesitter
      nvim-treesitter.withAllGrammars
      playground
      rainbow-delimiters-nvim
      nvim-autopairs
      vim-illuminate

      # bufferline
      bufferline-nvim
      vim-bbye

      # colorscheme display display
      (pkgs.vimUtils.buildVimPlugin {
        name = "inspecthi.vim";
        src = inputs.vim-inspecthi;
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "colorswatch.vim";
        src = inputs.vim-colorswatch;
      })
    ];
  };
}
