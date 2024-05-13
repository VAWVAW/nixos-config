{ lib, ... }: {
  environment.persistence."/persist".directories = [ "/var/lib/ntfy-sh" ];

  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;

      cache-file = "/var/lib/ntfy-sh/cache-file.db";
      base-url = "https://ntfy.nlih.de";
      attachment-cache-dir = "/var/lib/ntfy-sh/attachments";

      auth-file = "/var/lib/ntfy-sh/user.db";
      auth-default-access = "deny-all";
    };
  };

  systemd.services."ntfy-sh".serviceConfig.StateDirectory = lib.mkForce null;
  systemd.services."ntfy-sh".serviceConfig.DynamicUser = lib.mkForce false;
}
