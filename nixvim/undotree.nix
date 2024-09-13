{
  plugins.undotree.enable = true;

  keymaps = [{
    mode = "n";
    key = "<leader>u";
    action = ":UndotreeToggle<CR>";
    options = {
      noremap = true;
      silent = true;
    };
  }];
}
