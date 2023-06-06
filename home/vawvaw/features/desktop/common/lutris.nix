{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ lutris ];
    persistence."/local_persist/home/vawvaw" = {
      directories = [ ".config/lutris" ".cache/lutris" ".local/share/lutris" ];
    };
  };
}
