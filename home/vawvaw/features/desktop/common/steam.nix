{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ steam ];
    persistence."/local_persist/home/vawvaw" = {
      directories = [ ".local/share/Steam" ];
    };
  };
}
