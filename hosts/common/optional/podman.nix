{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  environment.persistence = {
    "/local_persist".directories = [
      "/var/lib/containers"
    ];
  };
}
