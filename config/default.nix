{ pkgs, helpers, ... }: {
  imports = [
    ./languages

    ./buffer.nix
    ./cmp.nix
    ./dap.nix
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
        rev = "4ecc09b7b7d2991a70bc721b7749ded962694115";
        hash = "sha256-zfHaLGwfM/kENJ0dapH/Na4h1TM/q7ZnpcLjEzi6bYg=";
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
