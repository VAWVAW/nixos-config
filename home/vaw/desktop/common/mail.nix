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
    ionos = rec {
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
        extraConfig = ''
          unvirtual-mailboxes *
          named-mailboxes "subscriptions" "/home/vaw/Maildir/subscriptions/Inbox"
          named-mailboxes "spline" "/home/vaw/Maildir/spline/Inbox"
          named-mailboxes "fu-berlin" "/home/vaw/Maildir/fu-berlin/Inbox"
          named-mailboxes "ionos" "/home/vaw/Maildir/ionos/Inbox"

          virtual-mailboxes "Drafts" "notmuch://?query=folder:ionos/Entwürfe"
          virtual-mailboxes "Junk" "notmuch://?query=folder:ionos/Spam"
          virtual-mailboxes "Sent" 'notmuch://?query=folder:"ionos/Gesendete Objekte"'
          virtual-mailboxes "Trash" "notmuch://?query=folder:ionos/Papierkorb"
        '';
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      notmuch = {
        enable = true;
        neomutt.virtualMailboxes = lib.mkForce [ ];
      };
      msmtp.enable = true;
    };
    fu-berlin = {
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
        extraConfig = ''
          unset trash

          unvirtual-mailboxes *
          named-mailboxes "subscriptions" "/home/vaw/Maildir/subscriptions/Inbox"
          named-mailboxes "spline" "/home/vaw/Maildir/spline/Inbox"
          named-mailboxes "fu-berlin" "/home/vaw/Maildir/fu-berlin/Inbox"
          named-mailboxes "ionos" "/home/vaw/Maildir/ionos/Inbox"

          virtual-mailboxes "Abgaben" "notmuch://?query=folder:fu-berlin/Abgaben"
          virtual-mailboxes "Drafts" "notmuch://?query=folder:fu-berlin/Entwürfe"
          virtual-mailboxes "Sent" "notmuch://?query=folder:fu-berlin/Gesendet"
        '';
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      notmuch = {
        enable = true;
        neomutt.virtualMailboxes = lib.mkForce [ ];
      };
      msmtp.enable = true;
    };
    spline = {
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
        extraConfig = ''
          unvirtual-mailboxes *
          named-mailboxes "subscriptions" "/home/vaw/Maildir/subscriptions/Inbox"
          named-mailboxes "spline" "/home/vaw/Maildir/spline/Inbox"
          named-mailboxes "fu-berlin" "/home/vaw/Maildir/fu-berlin/Inbox"
          named-mailboxes "ionos" "/home/vaw/Maildir/ionos/Inbox"

          virtual-mailboxes "Sent" "notmuch://?query=folder:spline/Sent"
          virtual-mailboxes "Trash" "notmuch://?query=folder:spline/Trash"
        '';
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      notmuch = {
        enable = true;
        neomutt.virtualMailboxes = lib.mkForce [ ];
      };
      msmtp.enable = true;
    };
    subscriptions = {
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

          unvirtual-mailboxes *
          named-mailboxes "subscriptions" "/home/vaw/Maildir/subscriptions/Inbox"
          named-mailboxes "spline" "/home/vaw/Maildir/spline/Inbox"
          named-mailboxes "fu-berlin" "/home/vaw/Maildir/fu-berlin/Inbox"
          named-mailboxes "ionos" "/home/vaw/Maildir/ionos/Inbox"

        '';
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      notmuch = {
        enable = true;
        neomutt.virtualMailboxes = lib.mkForce [ ];
      };
      msmtp.enable = true;
    };
  };

  programs = {
    neomutt = let
      get_i3block_signal = name:
        config.programs.i3blocks.bars."default"."${name}".data.signal;
      inherit ((builtins.head config.programs.waybar.settings)."custom/mail")
        signal;
    in {
      enable = true;
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
          key = "\\CD";
          action = "next-page";
          map = [ "index" "attach" "pager" ];
        }
        {
          key = "\\CU";
          action = "previous-page";
          map = [ "index" "attach" "pager" ];
        }
        {
          key = "g";
          action = "noop";
          map = [ "index" "attach" "pager" ];
        }
        {
          key = "gg";
          action = "first-entry";
          map = [ "index" "attach" ];
        }
        {
          key = "G";
          action = "last-entry";
          map = [ "index" "attach" ];
        }
        {
          key = "gg";
          action = "top";
          map = [ "pager" ];
        }
        {
          key = "G";
          action = "bottom";
          map = [ "pager" ];
        }

        {
          key = "k";
          action = "previous-line";
          map = [ "pager" ];
        }
        {
          key = "j";
          action = "next-line";
          map = [ "pager" ];
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
      };
      extraConfig = ''
        set pager_stop
        set menu_scroll

        set mail_check_stats=yes
        set mail_check_stats_interval=300

        set forward_decode
        set reply_to
        set reverse_name
        set include
        set forward_quote
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

        ${lib.optionalString config.programs.i3blocks.enable ''
          shutdown-hook 'echo `${pkgs.procps}/bin/pkill -SIGRTMIN+${
            get_i3block_signal "mail"
          } i3blocks`' ''}
        ${lib.optionalString config.programs.waybar.enable ''
          shutdown-hook 'echo `${pkgs.procps}/bin/pkill -SIGRTMIN+${builtins.toString signal} waybar`' ''}
      '';
    };
    mbsync.enable = true;
    notmuch = {
      enable = true;
      hooks = { preNew = "${pkgs.isync}/bin/mbsync --all"; };
    };
    msmtp.enable = true;
  };
}
