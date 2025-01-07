{ inputs, config, lib, ... }: {
  imports = [ inputs.simple-nixos-mailserver.nixosModule ];

  config = lib.mkIf config.mailserver.enable {

    programs.msmtp.enable = lib.mkForce false;

    environment.persistence = {
      "/persist".directories = [
        config.mailserver.dkimKeyDirectory
        config.mailserver.mailDirectory
        config.mailserver.sieveDirectory
        "/var/lib/rspamd"
        "/var/lib/redis-rspamd"
        "/var/lib/dhparams"
      ];
    };

    mailserver = {
      fqdn = "nlih.de";
      domains = [ "nlih.de" "vaw-valentin.de" "wiedekind1.de" ];

      loginAccounts = {
        "vaw@nlih.de" = {
          hashedPassword =
            "$2b$05$eLvLRB7/X8iFmaOsmTRuxeZsEAyFRsTDcx9khB1/AHLNV0yYe5oE6";
          aliases = [ "@nlih.de" "@vaw-valentin.de" "@wiedekind1.de" ];
        };
        "feuerwehr@nlih.de" = {
          hashedPassword =
            "$2b$05$xQePZUByxMzwfWIzFxIByeexTmTqlzbsDBWUg6KxEBWvAfovREYdm";
          aliases = [ "feuerwehr@vaw-valentin.de" ];
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

    services.rspamd.extraConfig = ''
      action {
        reject = null; # disable
        add_header = 10;
        greylist = 6;
      }
    '';

    services.borgbackup.jobs = let
      default = {
        user = config.mailserver.vmailUserName;
        group = config.mailserver.vmailGroupName;

        paths = [ config.mailserver.mailDirectory ];

        encryption.mode = "none";
        sshKey = config.sops.secrets."artemis-borg".path;
      };
    in {
      "local-mail" = default // { repo = "borg@localhost:."; };
      "remote-nyx-mail" = default // { repo = "borg@home.vaw-valentin.de:."; };
    };
  };
}
