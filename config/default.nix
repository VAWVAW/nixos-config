{ pkgs, ... }: {
  imports = [
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
  extraConfigLua = "require('nabla').enable_virt()";
  extraPlugins = [
    pkgs.vimPlugins.nabla-nvim

    (pkgs.vimUtils.buildVimPlugin {
      name = "vaw-colors";
      src = pkgs.fetchFromGitHub {
        owner = "vawvaw";
        repo = "nvim-colorscheme";
        rev = "493a025f96de086107e2b4fc5e5222e28feb7f47";
        hash = "sha256-8xkIUrrvhPyKLtritZ1rBMRWkjVKnA1705E0tYwy0J8=";
      };
    })
  ];
}
