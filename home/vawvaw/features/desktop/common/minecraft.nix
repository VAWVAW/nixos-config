{ pkgs, ... }: {
  home.packages = with pkgs; [ prismlauncher ];

  home.persistence."/persist/home/vawvaw".directories =
    [ ".local/share/PrismLauncher" ];
}
