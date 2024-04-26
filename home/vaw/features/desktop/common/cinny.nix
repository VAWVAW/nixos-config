{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ cinny-desktop ];

    persistence."/persist/home/vaw".directories = [
      {
        directory = ".cache/cinny";
        method = "symlink";
      }
      {
        directory = ".local/share/in.cinny.app";
        method = "symlink";
      }
    ];

  };
}
