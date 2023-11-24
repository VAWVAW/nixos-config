{ pkgs, ... }: {
  home.packages = with pkgs; [ obsidian ];

  home.persistence."/persist/home/vawvaw".directories = [{
    directory = ".config/obsidian";
    method = "symlink";
  }];
}
