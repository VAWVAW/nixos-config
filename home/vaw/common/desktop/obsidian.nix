{ config, pkgs, lib, ... }:
let cfg = config.programs.obsidian;
in {
  options.programs.obsidian.enable = lib.mkEnableOption "obsidian";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];

    home.persistence."/persist/home/vaw".directories = [{
      directory = ".config/obsidian";
      method = "symlink";
    }];
  };
}
