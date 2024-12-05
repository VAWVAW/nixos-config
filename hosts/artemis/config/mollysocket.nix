let dir = "/var/lib/private/mollysocket";
in {
  environment.persistence."/persist".directories = [ dir ];

  system.activationScripts."setup_private" = ''
    mkdir -p /var/lib/private
    chmod 700 /var/lib/private
  '';

  services.mollysocket = {
    enable = true;
    settings = {
      webserver = false;
      allowed_endpoints = [ "https://ntfy.nlih.de" ];
    };
    environmentFile = "${dir}/environ";
  };
}
