{ outputs, lib, ... }:
{
  programs.ssh = {
    enable = true;
  };

  home.persistence = {
    "/local_persist/home/vawvaw".directories = [ ".ssh" ];
  };
}
