{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = [ pkgs.vimPlugins.vim-nix ];
    settings = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
    };
  };
}
