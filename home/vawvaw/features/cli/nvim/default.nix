{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [ wl-clipboard ];

  programs.neovim = let
    formatLuaFileName =
      builtins.replaceStrings [ "/nix/store/" ".lua" ] [ "" "" ];
  in {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      source ${./theme.vim}

      set clipboard+=unnamed
      set fileencoding=utf-8
      set nobackup
      set undofile
      set updatetime=1000

      set hlsearch
      set ignorecase
      set smartcase

      set smartindent

      set showtabline=2
      set splitbelow
      set splitright

      set expandtab
      set shiftwidth=2
      set tabstop=2

      set nowrap
      set scrolloff=4
      set sidescrolloff=8

      set number
      set signcolumn=yes

      set noshowmode
      set completeopt=menuone,noselect
      set pumheight=10
    '';
    extraLuaConfig = ''
      package.path = package.path .. ";/nix/store/?.lua"
      require "${formatLuaFileName (toString ./keybinds.lua)}"
      require "${formatLuaFileName (toString ./cmp.lua)}"
      require "${formatLuaFileName (toString ./lsp.lua)}"
      require "${formatLuaFileName (toString ./treesitter.lua)}"
      require "${formatLuaFileName (toString ./gitsigns.lua)}"
      require "${formatLuaFileName (toString ./nvim-tree.lua)}"
      require "${formatLuaFileName (toString ./bufferline.lua)}"
      require "${formatLuaFileName (toString ./null-ls.lua)}"
      require "${formatLuaFileName (toString ./toggleterm.lua)}"
      require "${formatLuaFileName (toString ./lualine.lua)}"
      require "${formatLuaFileName (toString ./aerial.lua)}"
      require "${formatLuaFileName (toString ./telescope.lua)}"
    '';
    extraPackages = with pkgs; [ nodePackages.cspell ripgrep ];
    plugins = with pkgs.vimPlugins; [
      # misc
      plenary-nvim
      comment-nvim
      toggleterm-nvim

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
      null-ls-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "cspell.nvim";
        src = inputs.cspell-nvim;
      })
      aerial-nvim
      rust-tools-nvim

      # treesitter
      nvim-treesitter.withAllGrammars
      playground
      nvim-ts-rainbow
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
