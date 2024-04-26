{ pkgs, ... }: {
  home.packages = with pkgs; [ obsidian ];

  home.persistence."/persist/home/vaw".directories = [{
    directory = ".config/obsidian";
    method = "symlink";
  }];
}
