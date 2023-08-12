{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ lutris ];
    persistence."/persist/home/vawvaw" = {
      directories = [ ".config/lutris" ".cache/lutris" ".local/share/lutris" ];
    };
  };
}
