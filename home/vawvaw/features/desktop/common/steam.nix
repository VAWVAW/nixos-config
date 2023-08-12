{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ steam ];
    persistence."/persist/home/vawvaw" = {
      directories = [ ".local/share/Steam" ];
    };
  };
}
