{ config, pkgs, lib, ... }: {
  options.programs.lutris.enable = lib.mkEnableOption "lutris";

  config.home = lib.mkIf config.programs.lutris.enable {
    packages = with pkgs; [ lutris ];

    persistence."/persist/home/vaw".directories = [
      {
        directory = ".config/lutris";
        method = "symlink";
      }
      {
        directory = ".cache/lutris";
        method = "symlink";
      }
      {
        directory = ".local/share/lutris";
        method = "symlink";
      }
    ];
  };
}
