{ config, ... }: {
  sops.secrets."mail-system" = {
    sopsFile = ../../secrets/system.yaml;
    mode = "0400";
  };
  programs.msmtp = {
    enable = true;
    accounts.default = rec {
      auth = true;
      tls = true;
      host = "mx2fd8.netcup.net";
      port = 587;
      user = "system@vaw-valentin.de";
      from = user;
      passwordeval = "cat ${config.sops.secrets.mail-system.path}";
    };
  };
}
