{ pkgs, ... }: {
  home.packages = with pkgs; [ prismlauncher ];

  home.persistence."/persist/home/vaw".directories = [{
    directory = ".local/share/PrismLauncher";
    method = "symlink";
  }];
}
