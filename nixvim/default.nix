{ pkgs, helpers, ... }: {
  imports = [
    ./languages

    ./buffer.nix
    ./cmp.nix
    ./dap.nix
    ./dap-lldb.nix
    ./git.nix
    ./keybinds.nix
    ./lsp.nix
    ./lualine.nix
    ./none-ls.nix
    ./nvim-tree.nix
    ./outline.nix
    ./telescope.nix
    ./toggleterm.nix
    ./treesitter.nix
    ./undotree.nix
  ];

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
    project-nvim.enable = true;
  };

  colorscheme = "vaw-colors";
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vaw-colors";
      src = pkgs.fetchFromGitHub {
        owner = "vawvaw";
        repo = "nvim-colorscheme";
        rev = "a817843993c63afdd46c730b57720ed6b6ebcacd";
        hash = "sha256-W93zKg82jfr/rJHS05CuSKKJ9WIaVp0x1+qm2LY9egY=";
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
