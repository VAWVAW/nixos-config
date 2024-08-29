{ config, lib, ... }: {
  config = lib.mkIf config.virtualisation.podman.enable {
    virtualisation.podman = {
      dockerCompat = true;
      dockerSocket.enable = true;
    };

    environment.persistence = {
      "/persist".directories = [ "/var/lib/containers" ];
    };
  };
}
