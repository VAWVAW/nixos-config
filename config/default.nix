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
        rev = "15fc2e316316db6c4d8033e23fbee11ad197316d";
        hash = "sha256-NHf+i5zrFhYGQHj//2HGAYS+jm8K8e2LBhfDR6lCOUM=";
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
