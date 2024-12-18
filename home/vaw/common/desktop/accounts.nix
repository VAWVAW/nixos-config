{ inputs, config, pkgs, lib, ... }: {
  options.accounts.email.accounts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
      config = let
        removeNumber = name:
          builtins.head (builtins.tail (lib.splitString "_" name));
      in lib.mkMerge [{
        realName = lib.mkDefault "Valentin Wiedekind";
        userName = lib.mkDefault config.address;
        maildir.path = lib.mkDefault (removeNumber name);

        gpg = {
          key = lib.mkDefault "508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8";
          signByDefault = lib.mkDefault true;
        };

        neomutt = {
          enable = lib.mkDefault true;
          mailboxName = lib.mkDefault (removeNumber name);
        };
        mbsync = {
          enable = lib.mkDefault true;
          create = lib.mkDefault "both";
          expunge = lib.mkDefault "both";
        };
        notmuch = {
          enable = lib.mkDefault true;
          neomutt.virtualMailboxes = lib.mkForce [ ];
        };
        msmtp.enable = lib.mkDefault true;

        smtp.host = lib.mkDefault "nlih.de";
        imap = {
          host = lib.mkDefault "nlih.de";
          port = lib.mkDefault 993;
        };
      }];
    }));
  };

  config = lib.mkMerge [
    (lib.mkIf config.programs.mbsync.enable {
      sops.secrets = {
        "mail/ionos".sopsFile = "${inputs.self}/secrets/mail.yaml";
        "mail/fu-berlin".sopsFile = "${inputs.self}/secrets/mail.yaml";
        "mail/spline".sopsFile = "${inputs.self}/secrets/mail.yaml";
        "mail/subscriptions".sopsFile = "${inputs.self}/secrets/mail.yaml";
        "mail/feuerwehr".sopsFile = "${inputs.self}/secrets/mail.yaml";

        "mail/vaw".sopsFile = "${inputs.self}/secrets/mail.yaml";
        "mail/subscriptions-nlih".sopsFile = "${inputs.self}/secrets/mail.yaml";
        "mail/feuerwehr-nlih".sopsFile = "${inputs.self}/secrets/mail.yaml";
      };

      programs.neomutt.extraConfig = ''
        alternates '^valentin@wiedekind1.de$' '@vaw-valentin.de$' '@nlih.de$' '^vw7335fu@zedat.fu-berlin.de$' '^valentin.wiedekind@fu-berlin.de$' '^valentin.wiedekind@berliner-feuerwehr.de$'
      '';

      accounts.email.accounts = {
        "0_feuerwehr-nlih" = {
          address = "feuerwehr@nlih.de";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/feuerwehr-nlih".path
            }";

          imap.host = "nlih.de";
          gpg.signByDefault = false;
          msmtp.enable = false;
          neomutt = {
            extraConfig = ''
              unset trash

              # disable sending mail
              unset sendmail
            '';
            sendMailCommand =
              config.accounts.email.accounts."2_vaw".neomutt.sendMailCommand;
          };
        };
        "1_fu-berlin" = {
          address = "valentin.wiedekind@fu-berlin.de";
          userName = "vw7335fu@zedat.fu-berlin.de";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/fu-berlin".path
            }";

          imap.host = "mail.zedat.fu-berlin.de";
          smtp = {
            host = "mail.zedat.fu-berlin.de";
            port = 587;
            tls.useStartTls = true;
          };

          folders = {
            drafts = "Entwürfe";
            sent = "Gesendet";
          };
        };
        "2_vaw" = {
          primary = true;
          address = "vaw@nlih.de";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/vaw".path
            }";
          imap.host = "nlih.de";
        };
        "3_spline" = {
          realName = "vawvaw";
          address = "vawvaw@spline.de";
          userName = "vawvaw";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/spline".path
            }";

          imap.host = "imap.spline.de";
          smtp = {
            host = "mail.spline.de";
            port = 587;
            tls.useStartTls = true;
          };
        };
        "4_subscriptions-nlih" = {
          address = "subscriptions@nlih.de";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/subscriptions-nlih".path
            }";

          imap.host = "nlih.de";
          gpg.signByDefault = false;
          neomutt.extraConfig = "unset trash";
        };
        "5_feuerwehr" = {
          address = "feuerwehr@vaw-valentin.de";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/feuerwehr".path
            }";

          imap.host = "mx2fd8.netcup.net";
          smtp = {
            host = "mx2fd8.netcup.net";
            port = 587;
            tls.useStartTls = true;
          };

          neomutt = {
            extraConfig = ''
              unset trash

              # disable sending mail
              unset sendmail
            '';
            sendMailCommand =
              config.accounts.email.accounts."2_vaw".neomutt.sendMailCommand;
          };
        };
        "6_ionos" = {
          address = "valentin@wiedekind1.de";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/ionos".path
            }";

          smtp.host = "smtp.1und1.de";
          imap.host = "imap.1und1.de";

          folders = {
            drafts = "Entwürfe";
            sent = "Gesendete Objekte";
            trash = "Papierkorb";
          };
        };
        "7_subscriptions" = {
          address = "subscriptions@vaw-valentin.de";
          realName = "vaw";
          passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
              config.sops.secrets."mail/subscriptions".path
            }";

          imap.host = "mx2fd8.netcup.net";
          smtp = {
            host = "mx2fd8.netcup.net";
            port = 587;
            tls.useStartTls = true;
          };

          neomutt.extraConfig = "unset trash";
        };
      };
    })

    (lib.mkIf config.programs.khard.enable {
      accounts.contact.accounts = let
        inherit (config.accounts.contact) basePath;
        local = {
          type = "filesystem";
          fileExt = ".vcf";
          encoding = "UTF-8";
        };
        fromPath = path: {
          khard.enable = true;
          khal = {
            enable = true;
            priority = 5;
            readOnly = true;
            color = "#32831a";
          };
          local = local // { path = basePath + path; };
        };
      in {
        "Feuerwehr" = fromPath "/server/6f4ab084-0377-4a2d-9995-4c866fdc191d";
        "Schule" = fromPath "/server/45a81db2-5fbf-4c97-8da9-7fd22113a982";
        "Studium" = fromPath "/server/edf3ff2b-d373-478f-84d7-c145c8090ada";
        "Familie" = fromPath "/server/db2f1215-9d45-463e-9b96-c9928823e543";
        "server" = {
          inherit local;
          remote = {
            passwordCommand = [
              "${pkgs.coreutils-full}/bin/cat"
              "${config.sops.secrets."dav/server".path}"
            ];
            type = "carddav";
            url = "https://caldav.vaw-valentin.de";
            userName = "vawvaw";
          };
          vdirsyncer = {
            enable = true;
            collections = [ "from a" "from b" ];
            conflictResolution = "remote wins";
            metadata = [ "displayname" ];
          };
        };
      };
    })

    (lib.mkIf config.programs.khal.enable {
      accounts.calendar.accounts = let
        inherit (config.accounts.calendar) basePath;
        local = {
          type = "filesystem";
          fileExt = ".vcf";
          encoding = "UTF-8";
        };
      in {
        "Normal Events" = {
          primary = true;
          khal.enable = true;
          local = local // {
            path = basePath + "/server/b1ed46e0-d211-40aa-bc37-5e000b2f8b44";
          };
        };
        "FF" = {
          khal.enable = true;
          local = local // {
            path = basePath + "/server/102b9bf8-a34c-4fe3-b540-c1f2191c4c4f";
          };
        };
        "FU" = {
          khal = {
            enable = true;
            color = "#00ffe8";
            priority = 7;
          };
          local = local // { path = basePath + "/fu-berlin"; };
        };
        "Divera" = {
          khal = {
            enable = true;
            color = "#993232";
          };
          local = local // { path = basePath + "/divera"; };
        };
        "server" = {
          inherit local;
          remote = {
            passwordCommand = [
              "${pkgs.coreutils-full}/bin/cat"
              "${config.sops.secrets."dav/server".path}"
            ];
            type = "caldav";
            url = "https://caldav.vaw-valentin.de";
            userName = "vawvaw";
          };
          vdirsyncer = {
            enable = true;
            collections = [ "from a" "from b" ];
            conflictResolution = "remote wins";
            metadata = [ "displayname" "color" ];
          };
        };
      };
    })

    (lib.mkIf (config.programs.khard.enable || config.programs.khal.enable) {
      sops.secrets."dav/server" = { };
    })
  ];
}
