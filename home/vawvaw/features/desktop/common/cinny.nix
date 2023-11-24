{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ cinny-desktop ];

    persistence."/persist/home/vawvaw".directories = [
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
