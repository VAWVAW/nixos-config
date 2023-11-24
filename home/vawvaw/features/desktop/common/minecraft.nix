{ pkgs, ... }: {
  home.packages = with pkgs; [ prismlauncher ];

  home.persistence."/persist/home/vawvaw".directories = [{
    directory = ".local/share/PrismLauncher";
    method = "symlink";
  }];
}
