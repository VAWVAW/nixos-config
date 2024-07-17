{ config, pkgs, lib, ... }:
let gpg-key = "508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8";
in {
  sops.secrets = {
    "mail/ionos" = { };
    "mail/fu-berlin" = { };
    "mail/spline" = { };
    "mail/subscriptions" = { };
    "dav/server" = { };
  };

  programs.neomutt.extraConfig = ''
    alternates '^valentin@wiedekind1.de$' '@vaw-valentin.de$' '@nlih.de$' '^vw7335fu@zedat.fu-berlin.de$' '^valentin.wiedekind@fu-berlin.de$'
  '';
  accounts = {
    contact.accounts = let
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

    calendar.accounts = let
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

    email.accounts = {
      "ionos" = rec {
        address = "valentin@wiedekind1.de";
        realName = "Valentin Wiedekind";
        primary = true;
        imap.host = "imap.1und1.de";
        smtp.host = "smtp.1und1.de";
        userName = address;
        passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
            config.sops.secrets."mail/ionos".path
          }";

        folders = {
          inbox = "Inbox";
          drafts = "Entw&APw-rfe";
          sent = "Gesendete Objekte";
          trash = "Papierkorb";
        };

        gpg = {
          key = gpg-key;
          signByDefault = true;
        };
        neomutt = {
          enable = true;
          mailboxName = "ionos";
        };
        mbsync = {
          enable = true;
          create = "both";
        };
        notmuch = {
          enable = true;
          neomutt.virtualMailboxes = lib.mkForce [ ];
        };
        msmtp.enable = true;
      };
      "fu-berlin" = {
        address = "valentin.wiedekind@fu-berlin.de";
        realName = "Valentin Wiedekind";
        imap = {
          host = "mail.zedat.fu-berlin.de";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "mail.zedat.fu-berlin.de";
          port = 587;
          tls.useStartTls = true;
        };
        userName = "vw7335fu@zedat.fu-berlin.de";
        passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
            config.sops.secrets."mail/fu-berlin".path
          }";

        folders = {
          drafts = "Entw&APw-rfe";
          sent = "Gesendet";
        };

        gpg = {
          key = gpg-key;
          signByDefault = true;
        };
        neomutt = {
          enable = true;
          mailboxName = "fu-berlin";
        };
        mbsync = {
          enable = true;
          create = "both";
        };
        notmuch = {
          enable = true;
          neomutt.virtualMailboxes = lib.mkForce [ ];
        };
        msmtp.enable = true;
      };
      "spline" = {
        address = "vawvaw@spline.de";
        realName = "vawvaw";
        imap = {
          host = "imap.spline.de";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "mail.spline.de";
          port = 587;
          tls.useStartTls = true;
        };
        userName = "vawvaw";
        passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
            config.sops.secrets."mail/spline".path
          }";

        gpg = {
          key = gpg-key;
          signByDefault = true;
        };
        neomutt = {
          enable = true;
          mailboxName = "spline";
        };
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          remove = "both";
        };
        notmuch = {
          enable = true;
          neomutt.virtualMailboxes = lib.mkForce [ ];
        };
        msmtp.enable = true;
      };
      "subscriptions" = {
        address = "subscriptions@vaw-valentin.de";
        realName = "vaw";
        imap = {
          host = "mx2fd8.netcup.net";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "mx2fd8.netcup.net";
          port = 587;
          tls.useStartTls = true;
        };
        userName = "subscriptions@vaw-valentin.de";
        passwordCommand = "${pkgs.coreutils-full}/bin/cat ${
            config.sops.secrets."mail/subscriptions".path
          }";
        neomutt = {
          enable = true;
          mailboxName = "subscriptions";
          extraConfig = ''
            unset trash
          '';
        };
        mbsync = {
          enable = true;
          create = "both";
        };
        notmuch = {
          enable = true;
          neomutt.virtualMailboxes = lib.mkForce [ ];
        };
        msmtp.enable = true;
      };
    };
  };
}
