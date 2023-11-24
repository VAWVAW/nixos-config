{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.persistence."/persist/home/vawvaw".directories = [{
    directory = ".local/share/direnv";
    method = "symlink";
  }];
}
