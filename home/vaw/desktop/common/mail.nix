{ config, pkgs, lib, ... }:
let gpg-key = "508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8";
in {
  sops.secrets = {
    "mail/ionos" = { };
    "mail/fu-berlin" = { };
    "mail/spline" = { };
    "mail/subscriptions" = { };
  };

  home.persistence."/persist/home/vaw".directories = [{
    directory = "Maildir";
    method = "bindfs"; # allow home-manager to manage mailboxes
  }];

  accounts.email.accounts = {
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

  programs = {
    neomutt = {
      enable = true;
      vimKeys = true;
      binds = [
        # sidebar navigation
        {
          key = "<down>";
          action = "sidebar-next";
          map = [ "index" "pager" ];
        }
        {
          key = "<up>";
          action = "sidebar-prev";
          map = [ "index" "pager" ];
        }
        {
          key = "<right>";
          action = "sidebar-open";
          map = [ "index" "pager" ];
        }
        # index key bindings
        {
          key = "<tab>";
          action = "sync-mailbox";
          map = [ "index" ];
        }
        {
          key = "<space>";
          action = "collapse-thread";
          map = [ "index" ];
        }
        {
          key = "<return>";
          action = "display-message";
          map = [ "index" ];
        }
        # file brower
        {
          key = "e";
          action = "descend-directory";
          map = [ "browser" ];
        }
      ];
      macros = [
        {
          key = "\\CB";
          action = "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>";
          map = [ "index" "pager" ];
        }
        {
          key = "\\CB";
          action = "<pipe-entry> ${pkgs.urlscan}/bin/urlscan<Enter>";
          map = [ "attach" "compose" ];
        }
        {
          key = "y";
          action = "<change-folder>?<toggle-mailboxes>";
          map = [ "index" ];
        }
      ];
      sidebar = {
        enable = true;
        width = 24;
      };
      settings = {
        status_chars = ''" *%A"'';
        status_format = ''
          "───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───"'';
        date_format = ''"%d.%m.%y"'';
        index_format = ''"[%?X?A& ?%Z] %D  %-25.25F  %s"'';
        sort = "threads";
        sort_aux = "reverse-last-date-received";

        pager_index_lines = "10";
        pager_context = "3";
        quote_regex = ''"^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"'';

        forward_format = ''"Fwd: %s"'';
        attribution = ''"On %d, %n wrote:"'';
        edit_headers = "yes";
        send_charset = "utf-8";

        pager_stop = "yes";
        menu_scroll = "yes";
        mail_check_stats = "yes";
        mail_check_stats_interval = "300";

        forward_decode = "yes";
        reverse_name = "yes";
        forward_quote = "yes";
      };
      extraConfig = ''
        unset markers

        # header
        ignore *
        unignore from: to: cc: date: subject:
        unhdr_order *
        hdr_order from: to: cc: date: subject:

        # colors
        color hdrdefault blue black
        color quoted blue black
        color signature blue black
        color attachment yellow black
        color prompt brightmagenta black
        color message brightyellow black
        color error brightred black
        color indicator black yellow
        color status brightgreen blue
        color tree white black
        color normal white black
        color markers yellow black
        color search white black
        color tilde brightmagenta black
        color index blue black ~F
        color index yellow black "~N|~O"
      '';
    };
    mbsync.enable = true;
    notmuch = {
      enable = true;
      hooks = let
        i3blocks_signal =
          config.programs.i3blocks.bars."default"."mail".data.signal;
        waybar_signal = builtins.toString
          (builtins.head config.programs.waybar.settings)."custom/mail".signal;
      in {
        preNew = "${pkgs.isync}/bin/mbsync --all";
        postNew = ''
          ${lib.optionalString config.programs.i3blocks.enable
          "${pkgs.procps}/bin/pkill -SIGRTMIN+${i3blocks_signal} i3blocks"}
          ${lib.optionalString config.programs.waybar.enable
          "${pkgs.procps}/bin/pkill -SIGRTMIN+${waybar_signal} waybar"}
        '';
      };
    };
    msmtp.enable = true;
  };
}
