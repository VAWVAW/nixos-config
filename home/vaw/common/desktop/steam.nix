{ config, pkgs, lib, ... }: {
  options.programs.steam.enable = lib.mkEnableOption "steam";

  config.home = lib.mkIf config.programs.steam.enable {
    packages = with pkgs; [ steam ];

    persistence."/persist/home/vaw".directories = [{
      directory = ".local/share/Steam";
      method = "symlink";
    }];
  };
}
