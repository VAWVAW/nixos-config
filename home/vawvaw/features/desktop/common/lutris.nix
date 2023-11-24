{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ lutris ];

    persistence."/persist/home/vawvaw".directories = [
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
