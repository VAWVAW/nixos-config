let
  data_dir = "/persist/var/lib/pihole";
  admin_port = 8080;
in {
  networking.firewall = {
    allowedTCPPorts = [ 53 admin_port ];
    allowedUDPPorts = [ 53 ];
  };
  virtualisation.oci-containers.containers."pihole" = {
    image = "pihole/pihole:latest";

    ports = [
      # dns
      "53:53/tcp"
      "53:53/udp"
      # admin panel
      "${builtins.toString admin_port}:80/tcp"
    ];
    volumes = [
      "${data_dir}/etc-pihole:/etc/pihole"
      "${data_dir}/etc-dnsmasq.d:/etc/dnsmasq.d"
    ];
    environment = { TZ = "Europe/Berlin"; };
  };
}
