{ pkgs, helpers, ... }: {
  imports = [
    ./languages

    ./buffer.nix
    ./cmp.nix
    ./git.nix
    ./keybinds.nix
    ./lsp.nix
    ./lualine.nix
    ./none-ls.nix
    ./nvim-tree.nix
    ./telescope.nix
    ./toggleterm.nix
    ./treesitter.nix
    ./undotree.nix
  ];
  languages.all.enable = true;

  # TODO: add plugin specific keybinds

  clipboard.register = "unnamed";
  opts = {
    mouse = "";
    ignorecase = true;
    smartcase = true;
    smartindent = true;

    splitbelow = true;
    splitright = true;

    foldlevelstart = 99;

    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;

    wrap = false;
    scrolloff = 3;
    sidescrolloff = 8;

    number = true;
    relativenumber = true;
    signcolumn = "yes";

    showmode = false;
    completeopt = [ "menuone" "noselect" ];
  };

  plugins = {
    comment.enable = true;
    nvim-autopairs.enable = true;
    project-nvim.enable = true;
  };

  colorscheme = "vaw-colors";
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vaw-colors";
      src = pkgs.fetchFromGitHub {
        owner = "vawvaw";
        repo = "nvim-colorscheme";
        rev = "93875eb30659912424cfffa53bb368eb24f1219f";
        hash = "sha256-f2IXMkcGGLP9DofT6uXlEIQ7s0Z1M+NXmliievImwh4=";
      };
    })

    pkgs.vimPlugins.nabla-nvim
  ];

  autoCmd = [{
    event = "FileType";
    pattern = "markdown";
    callback = helpers.mkRaw ''require("nabla").enable_virt'';
  }];
}
