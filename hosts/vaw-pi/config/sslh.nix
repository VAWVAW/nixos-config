{
  services.sslh = {
    enable = true;
    transparent = true;
    port = 443;
    listenAddresses = [
      "192.168.2.101"
      "home.vaw-valentin.de"
    ];
    appendConfig = ''
     protocols:
     (
       { name: "ssh"; service: "ssh"; host: "localhost"; port: "22"; probe: "builtin"; },
       { name: "tls"; host: "127.0.0.1"; port: "443"; probe: "builtin"; },
     );
    '';
  };
}
