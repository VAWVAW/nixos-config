{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ steam ];

    persistence."/persist/home/vaw".directories = [{
      directory = ".local/share/Steam";
      method = "symlink";
    }];
  };
}
