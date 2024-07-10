{ lib, ... }:
let host = "127.0.0.1:2586";
in {
  environment.persistence."/persist".directories = [ "/var/lib/ntfy-sh" ];

  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = host;
      behind-proxy = true;

      cache-file = "/var/lib/ntfy-sh/cache-file.db";
      base-url = "https://ntfy.nlih.de";
      attachment-cache-dir = "/var/lib/ntfy-sh/attachments";

      auth-file = "/var/lib/ntfy-sh/user.db";
      auth-default-access = "deny-all";
    };
  };
  systemd.services."ntfy-sh".serviceConfig = {
    StateDirectory = lib.mkForce null;
    DynamicUser = lib.mkForce false;
  };

  services.nginx.virtualHosts."ntfy.nlih.de".locations."/" = {
    proxyPass = "http://${host}/";
    proxyWebsockets = true;
  };
}
