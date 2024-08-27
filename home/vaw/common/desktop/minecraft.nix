{ config, pkgs, lib, ... }: {
  options.programs.minecraft.enable = lib.mkEnableOption "minecraft";

  config = lib.mkIf config.programs.minecraft.enable {
    home.packages = with pkgs; [ prismlauncher ];

    home.persistence."/persist/home/vaw".directories = [{
      directory = ".local/share/PrismLauncher";
      method = "symlink";
    }];
  };
}
