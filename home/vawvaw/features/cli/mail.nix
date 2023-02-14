{ config, pkgs, lib, ... }:
let
  gpg-key = "508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8";
in
{
  sops.secrets = {
    "mail/ionos" = { };
    "mail/iserv" = { };
  };

  accounts.email.accounts = {
    ionos = rec {
      address = "valentin@wiedekind1.de";
      realName = "Valentin Wiedekind";
      primary = true;
      imap.host = "imap.1und1.de";
      smtp.host = "smtp.1und1.de";
      userName = address;
      passwordCommand = "${pkgs.coreutils-full}/bin/cat $XDG_RUNTIME_DIR/secrets/mail/ionos";

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
          unvirtual-mailboxes
          virtual-mailboxes "ionos-Inbox" "notmuch://?query=folder:ionos/Inbox"
          virtual-mailboxes "ionos-Drafts" "notmuch://?query=folder:ionos/Entwürfe"
          virtual-mailboxes "ionos-Junk" "notmuch://?query=folder:ionos/Spam"
          virtual-mailboxes "ionos-Sent" 'notmuch://?query=folder:"ionos/Gesendete Objekte"'
          virtual-mailboxes "ionos-Trash" "notmuch://?query=folder:ionos/Papierkorb"
        '';
      };
      mbsync = {
        enable = true;
        create = "maildir";
        extraConfig.channel = {
          Patterns = [ "INBOX" "*" "!Entwürfe" ];
        };
      };
      notmuch.enable = true;
      msmtp.enable = true;
    };
    iserv = rec {
      address = "valentin.wiedekind@ghg.berlin";
      realName = "Valentin Wiedekind";
      imap = {
        host = "ghg.berlin";
        port = 143;
        tls.useStartTls = true;
      };
      smtp = {
        host = "ghg.berlin";
        port = 587;
        tls.useStartTls = true;
      };
      userName = "valentin.wiedekind";
      passwordCommand = "${pkgs.coreutils-full}/bin/cat $XDG_RUNTIME_DIR/secrets/mail/iserv";

      folders = {
        inbox = "INBOX";
        drafts = "Drafts";
        sent = "Sent";
        trash = "Trash";
      };

      gpg = {
        key = gpg-key;
        signByDefault = true;
      };
      neomutt = {
        enable = true;
        mailboxName = "iserv";
        extraConfig = ''
          unvirtual-mailboxes
          virtual-mailboxes "iserv-Inbox" "notmuch://?query=folder:iserv/INBOX"
          virtual-mailboxes "iserv-Drafts" "notmuch://?query=folder:iserv/Drafts"
          virtual-mailboxes "iserv-Junk" "notmuch://?query=folder:iserv/Junk"
          virtual-mailboxes "iserv-Sent" "notmuch://?query=folder:iserv/Sent"
          virtual-mailboxes "iserv-Trash" "notmuch://?query=folder:iserv/Trash"
        '';
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      notmuch.enable = true;
      msmtp.enable = true;
    };
  };

  programs = {
    neomutt =
      let
        get_i3block_signal = name: (builtins.head (builtins.filter (block: block.name == name) config.programs.i3blocks.blocks)).signal;
      in
      {
        enable = true;
        binds = [
          # sidebar navigation
          { key = "<down>"; action = "sidebar-next"; map = [ "index" "pager" ]; }
          { key = "<up>"; action = "sidebar-prev"; map = [ "index" "pager" ]; }
          { key = "<right>"; action = "sidebar-open"; map = [ "index" "pager" ]; }
          # index key bindings
          { key = "<tab>"; action = "sync-mailbox"; map = [ "index" ]; }
          { key = "<space>"; action = "collapse-thread"; map = [ "index" ]; }

          { key = "\\CD"; action = "next-page"; map = [ "index" "attach" "pager" ]; }
          { key = "\\CU"; action = "previous-page"; map = [ "index" "attach" "pager" ]; }
          { key = "g"; action = "noop"; map = [ "index" "attach" "pager" ]; }
          { key = "gg"; action = "first-entry"; map = [ "index" "attach" ]; }
          { key = "G"; action = "last-entry"; map = [ "index" "attach" ]; }
          { key = "gg"; action = "top"; map = [ "pager" ]; }
          { key = "G"; action = "bottom"; map = [ "pager" ]; }

          { key = "k"; action = "previous-line"; map = [ "pager" ]; }
          { key = "j"; action = "next-line"; map = [ "pager" ]; }
        ];
        macros = [
          { key = "\\CB"; action = "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>"; map = [ "index" "pager" ]; }
          { key = "\\CB"; action = "<pipe-entry> ${pkgs.urlscan}/bin/urlscan<Enter>"; map = [ "attach" "compose" ]; }
        ];
        sidebar = {
          enable = true;
          width = 24;
        };
        settings = {
          status_chars = "\" *%A\"";
          status_format = "\"───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───\"";
          date_format = "\"%d.%m.%y\"";
          index_format = "\"[%?X?A& ?%Z] %D  %-25.25F  %s\"";
          sort = "threads";
          sort_aux = "reverse-last-date-received";

          pager_index_lines = "10";
          pager_context = "3";
          quote_regex = "\"^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+\"";

          forward_format = "\"Fwd: %s\"";
          attribution = "\"On %d, %n wrote:\"";
          edit_headers = "yes";
          send_charset = "utf-8";
        };
        extraConfig = ''
          set pager_stop
          set menu_scroll

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

          startup-hook "exec ${pkgs.notmuch}/bin/notmuch new"
          ${lib.optionalString config.programs.i3blocks.enable ''shutdown-hook "exec ${pkgs.procps}/bin/pkill -SIGRTMIN+${get_i3block_signal "mail"} i3blocks"''}
        '';
      };
    mbsync.enable = true;
    notmuch = {
      enable = true;
      hooks = {
        preNew = "${pkgs.isync}/bin/mbsync --all";
      };
    };
    msmtp.enable = true;
  };
}
