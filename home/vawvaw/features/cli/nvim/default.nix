{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
  ];

  programs.neovim =
    let
      formatLuaFileName = s: builtins.replaceStrings [ "/nix/store/" ".lua" ] [ "" "" ] s;
    in
    {
      enable = true;
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
        require "${formatLuaFileName (toString ./keybinds.lua)}"
        require "${formatLuaFileName (toString ./cmp.lua)}"
        require "${formatLuaFileName (toString ./lsp.lua)}"
      '';
      extraPackages = with pkgs; [
        pyright
      ];
      plugins = with pkgs.vimPlugins; [
        vim-nix

        # completion
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp_luasnip

        # snippets
        luasnip
        friendly-snippets

        # lsp
        nvim-lspconfig
        cmp-nvim-lsp

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
