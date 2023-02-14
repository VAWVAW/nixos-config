# This file (and the global directory) holds config that I use on all hosts
{ pkgs, inputs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      xdg-utils
    ];

    shells = [ pkgs.bash pkgs.zsh ];
  };

  programs = {
    command-not-found.dbPath =
      inputs.flake-programs-sqlite.packages.${pkgs.system}.programs-sqlite;
    zsh.enable = true;
    fuse.userAllowOther = true;
    git.enable = true;
    vim.defaultEditor = true;
  };
}
