{ config, lib, ... }: {
  config = lib.mkIf config.programs.direnv.enable {
    programs.direnv.nix-direnv.enable = true;

    home.persistence."/persist/home/vaw".directories = [{
      directory = ".local/share/direnv";
      method = "symlink";
    }];
  };
}
