{ config, pkgs, lib, ... }: {
  config = let
    removeHomePrefix = path:
      builtins.replaceStrings [ config.home.homeDirectory ] [ "" ] path;
  in lib.mkMerge [
    (lib.mkIf config.programs.notmuch.enable {
      home.persistence."/persist/home/vaw".directories = [{
        directory = removeHomePrefix config.accounts.email.maildirBasePath;
        method = "bindfs"; # allow home-manager to manage mailboxes
      }];

      accounts.email.maildirBasePath = "Maildir";

      programs = {
        mbsync.enable = true;
        notmuch = {
          hooks = let
            i3blocks_signal =
              config.programs.i3blocks.bars."default"."mail".data.signal;
            waybar_signal = builtins.toString (builtins.head
              config.programs.waybar.settings)."custom/mail".signal;
          in {
            preNew = "${pkgs.isync}/bin/mbsync --all";
            postNew = ''
              ${lib.optionalString config.programs.i3blocks.enable
              "${pkgs.procps}/bin/pkill -SIGRTMIN+${i3blocks_signal} i3blocks || ${pkgs.coreutils}/bin/true"}
              ${lib.optionalString config.programs.waybar.enable
              "${pkgs.procps}/bin/pkill -SIGRTMIN+${waybar_signal} waybar || ${pkgs.coreutils}/bin/true"}
            '';
          };
        };
      };

      systemd.user.services."mail-sync" = {
        Unit = {
          Description = "run `notmuch new` on login";
          After = [ "sops-nix.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.notmuch}/bin/notmuch new";
        };
        Install.WantedBy = [ "default.target" ];
      };
    })

    (lib.mkIf config.programs.neomutt.enable {
      programs = {
        msmtp.enable = true;
        notmuch.enable = true;
        neomutt = {
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
          ] ++ lib.optional config.programs.khard.enable {
            key = "A";
            action =
              "<pipe-message>${pkgs.khard}/bin/khard add-email --headers=from,cc,to --skip-already-added<return>";
            map = [ "index" "pager" ];
          };
          sidebar = {
            enable = true;
            width = 24;
          };
          settings = {
            crypt_opportunistic_encrypt = "yes";
            fcc_clear = "yes";

            query_command = lib.mkIf config.programs.khard.enable
              ''"echo %s | xargs ${pkgs.khard}/bin/khard email --parsable --"'';

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
      };
    })

    (lib.mkIf config.programs.khard.enable {
      home.persistence."/persist/home/vaw".directories = [{
        directory = removeHomePrefix config.accounts.contact.basePath;
        method = "symlink";
      }];

      accounts.contact.basePath = ".dav/contacts";

      programs.vdirsyncer.enable = true;

      programs.khard.settings."contact table".localize_dates = "yes";
    })

    (lib.mkIf config.programs.khal.enable {
      home.persistence."/persist/home/vaw".directories = [{
        directory = removeHomePrefix config.accounts.calendar.basePath;
        method = "symlink";
      }];

      accounts.calendar.basePath = ".dav/calendar";

      programs.vdirsyncer.enable = true;

      programs.khal.locale = {
        dateformat = "%d. %a";
        datetimeformat = "%d. %a %H:%M";
        longdateformat = "%d.%m.%Y";
        longdatetimeformat = "%d.%m.%Y %H:%M";
        timeformat = "%H:%M";
      };
    })

    (lib.mkIf config.programs.vdirsyncer.enable {
      sops.secrets = {
        "dav/fu-url" = { };
        "dav/divera-url" = { };
      };

      systemd.user.services."sync-dav" = {
        Unit = {
          Description = "vdirsyncer and khal import";
          After = [ "sops-nix.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = let calendar_accounts = config.accounts.calendar.accounts;
          in [
            "${pkgs.vdirsyncer}/bin/vdirsyncer discover"
            "${pkgs.vdirsyncer}/bin/vdirsyncer metasync"
            "${pkgs.vdirsyncer}/bin/vdirsyncer sync"
          ] ++ lib.optionals config.programs.khal.enable [
            "/bin/sh -c '${pkgs.curl}/bin/curl $(${pkgs.coreutils}/bin/cat ${
              config.sops.secrets."dav/fu-url".path
            }) | ${pkgs.khal}/bin/khal import --batch -a \"${
              calendar_accounts."FU".name
            }\"'"
            "/bin/sh -c '${pkgs.curl}/bin/curl $(${pkgs.coreutils}/bin/cat ${
              config.sops.secrets."dav/divera-url".path
            }) | ${pkgs.khal}/bin/khal import --batch -a \"${
              calendar_accounts."Divera".name
            }\"'"
          ];
        };
        Install.WantedBy = [ "default.target" ];
      };
      systemd.user.timers."sync-dav" = {
        Unit.Description = "vdirsyncer and khal import";
        Timer = {
          OnCalendar = "*:0/15";
          Unit = "sync-dav.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    })
  ];
}
