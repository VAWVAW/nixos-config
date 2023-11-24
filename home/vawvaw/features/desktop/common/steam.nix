{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ steam ];

    persistence."/persist/home/vawvaw".directories = [{
      directory = ".local/share/Steam";
      method = "symlink";
    }];
  };
}
