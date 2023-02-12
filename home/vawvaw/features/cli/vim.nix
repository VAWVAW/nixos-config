{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.vim-nix
    ];
    settings = {
      number = true;
      tabstop = 2;
      shiftwidth = 2;
    };
    extraConfig = ''
      set clipboard=unnamedplus
      nnoremap <Space> i_<Esc>r
      nnoremap <Return> o<Esc>
      nnoremap j gj
      nnoremap k gk
    '';
  };
}
