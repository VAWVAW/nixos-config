{ inputs, config, pkgs, lib, ... }: {
  imports = [ inputs.simple-nixos-mailserver.nixosModule ];

  config = lib.mkIf config.mailserver.enable {

    programs.msmtp.enable = lib.mkForce false;

    environment.persistence = {
      "/persist".directories = [
        config.mailserver.dkimKeyDirectory
        config.mailserver.mailDirectory
        config.mailserver.sieveDirectory
      ];
    };

    mailserver = {
      fqdn = "nlih.de";
      domains = [ "nlih.de" "vaw-valentin.de" ];

      loginAccounts = {
        "vaw@nlih.de" = {
          hashedPassword =
            "$2b$05$eLvLRB7/X8iFmaOsmTRuxeZsEAyFRsTDcx9khB1/AHLNV0yYe5oE6";
          aliases = [ "@nlih.de" "@vaw-valentin.de" ];
        };
        "feuerwehr@nlih.de" = {
          hashedPassword =
            "$2b$05$xQePZUByxMzwfWIzFxIByeexTmTqlzbsDBWUg6KxEBWvAfovREYdm";
        };
        "subscriptions@nlih.de" = {
          hashedPassword =
            "$2b$05$iNXe4KZ5M7YoH8PGQg2ChuylglExHjV9LZ2Z3S5AMQZz0M6WnsHDi";
          aliases = [
            "subscriptions@vaw-valentin.de"
            "github@vaw-valentin.de"
            "gitlab@vaw-valentin.de"
            "nixos-discourse@vaw-valentin.de"
            "tor-announce@vaw-valentin.de"
          ];
        };
      };
      certificateScheme = "acme";
    };

    services.nginx.virtualHosts."${config.mailserver.fqdn}" = {
      onlySSL = false;
      addSSL = true;

      globalRedirect = "nlih.de";
    };

    services.borgbackup.jobs."remote-nyx-mail" = {
      user = config.mailserver.vmailUserName;
      group = config.mailserver.vmailGroupName;

      paths = [ config.mailserver.mailDirectory ];

      encryption.mode = "none";
      repo = "borg@home.vaw-valentin.de:.";
      environment."BORG_RSH" =
        "${pkgs.openssh}/bin/ssh -oBatchMode=yes -i %d/ssh_key";
    };
    systemd.services."borgbackup-job-remote-nyx-mail".serviceConfig.LoadCredential =
      [ "ssh_key:${config.sops.secrets."artemis-nyx-borg".path}" ];

  };
}
