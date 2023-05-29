{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
  ];

  programs.neovim = let
    formatLuaFileName = s: builtins.replaceStrings ["/nix/store/" ".lua"] ["" ""] s;
    keybinds = pkgs.writeText "keybinds.lua" ''
      local opts = { noremap = true, silent = true }

      local term_opts = { silent = true }

      -- Shorten function name
      local keymap = vim.api.nvim_set_keymap

      --Remap space as leader key
      keymap("", "<Space>", "<Nop>", opts)
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Modes
      --   normal_mode = "n",
      --   insert_mode = "i",
      --   visual_mode = "v",
      --   visual_block_mode = "x",
      --   term_mode = "t",
      --   command_mode = "c",

      -- Normal --
      -- Better window navigation
      keymap("n", "<C-h>", "<C-w>h", opts)
      keymap("n", "<C-j>", "<C-w>j", opts)
      keymap("n", "<C-k>", "<C-w>k", opts)
      keymap("n", "<C-l>", "<C-w>l", opts)

      keymap("n", "<leader>e", ":Lex 10<cr>", opts)

      -- Resize with arrows
      keymap("n", "<C-Up>", ":resize +2<CR>", opts)
      keymap("n", "<C-Down>", ":resize -2<CR>", opts)
      keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
      keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

      -- Navigate buffers
      keymap("n", "<A-l>", ":bnext<CR>", opts)
      keymap("n", "<A-h>", ":bprevious<CR>", opts)

      -- Visual --
      -- Stay in indent mode
      keymap("v", "<", "<gv", opts)
      keymap("v", ">", ">gv", opts)

      -- Move text up and down
      keymap("v", "<A-j>", ":m .+1<CR>==", opts)
      keymap("v", "<A-k>", ":m .-2<CR>==", opts)
      keymap("v", "p", '"_dP', opts)

      -- Visual Block --
      -- Move text up and down
      keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
      keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

      -- Terminal --
      -- Better terminal navigation
      keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
      keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
      keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
      keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
    '';
  in {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      (pkgs.vimUtils.buildVimPlugin {
        name = "inspecthi.vim";
        src = inputs.vim-inspecthi;
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "colorswatch.vim";
        src = inputs.vim-colorswatch;
      })
    ];
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
      set signcolumn=number

      set noshowmode
      set completeopt=menuone,noselect
      set pumheight=10

      nnoremap <Space> i_<Esc>r
      nnoremap <Return> o<Esc>
    '';
    extraLuaConfig = ''
      package.path = package.path .. ";/nix/store/?.lua"
      require "${formatLuaFileName (toString keybinds)}"
    '';
  };
}
