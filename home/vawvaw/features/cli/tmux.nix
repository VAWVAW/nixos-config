{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    newSession = true;
    secureSocket = false;
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
