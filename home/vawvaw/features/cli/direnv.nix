{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.persistence."/local_persist/home/vawvaw" = {
    directories = [ ".local/share/direnv" ];
  };
}
