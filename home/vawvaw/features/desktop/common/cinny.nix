{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      cinny-desktop
    ];
    persistence."/local_persist/home/vawvaw" = {
      directories = [
        ".cache/cinny"
        ".local/share/in.cinny.app"
      ];
    };
  };
}
