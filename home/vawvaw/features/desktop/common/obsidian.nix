{ pkgs, ... }: {
  home.packages = with pkgs; [ obsidian ];

  home.persistence."/persist/home/vawvaw".directories = [ ".config/obsidian" ];
}
