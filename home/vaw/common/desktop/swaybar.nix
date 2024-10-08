{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.programs.i3blocks.enable {
    wayland.windowManager.sway.config.bars = [{
      statusCommand =
        "${pkgs.i3blocks}/bin/i3blocks -c ~/.config/i3blocks/default";
      trayOutput = "*";
      position = "bottom";
      colors = let inherit (config.wayland.windowManager.sway.config) colors;
      in {
        statusline = "#ffffff";
        background = "#000000";
        focusedWorkspace = { inherit (colors.focused) background border text; };
        bindingMode = { inherit (colors.urgent) background border text; };
        activeWorkspace = {
          inherit (colors.focusedInactive) background border text;
        };
        inactiveWorkspace = {
          inherit (colors.unfocused) background border text;
        };
      };
    }];

    programs.i3blocks = let i3blocks_volume_signal = "10";
    in {
      # scripts are derived from https://github.com/vivien/i3blocks-contrib
      bars."default" = let
        mail_script = pkgs.writeTextFile {
          name = "mail";
          executable = true;
          text = ''
            notmuch new >/dev/null 2>/dev/null
            notmuch count tag:unread 2>/dev/null | sed -E "s;(.+);mail: \1;" | sed "s;mail: 0;;"
          '';
        };
        spotify_script = pkgs.writeTextFile {
          name = "spotify";
          executable = true;
          text = ''
            case $button in
              1)
                ${pkgs.spotifython-cli}/bin/spotifython-cli prev ;;
              2)
                ${pkgs.spotifython-cli}/bin/spotifython-cli play-pause ;;
              3)
                ${pkgs.spotifython-cli}/bin/spotifython-cli next ;;
              4)
                ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+; pkill -SIGRTMIN+${i3blocks_volume_signal} i3blocks ;;
              5)
                ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-; pkill -SIGRTMIN+${i3blocks_volume_signal} i3blocks ;;
            esac

            metadata=$(${pkgs.spotifython-cli}/bin/spotifython-cli metadata -j title artist_name is_playing)

            is_playing=$(echo $metadata | ${pkgs.python3}/bin/python3 -c "import sys, json; print(json.load(sys.stdin)['is_playing'])")
            if [[ "$is_playing" == "False" ]]
            then
                exit
            fi

            title=$(echo $metadata | ${pkgs.python3}/bin/python3 -c "import sys, json; print(json.load(sys.stdin)['title'])" | sed -E "s;\[.*|.[fF]eat\..*;;g" | sed -E "s;(.{30}).{3,};\1...;")
            artist=$(echo $metadata | ${pkgs.python3}/bin/python3 -c "import sys, json; print(json.load(sys.stdin)['artist_name'])" | sed -E "s;(.{18}).{3,};\1...;")

            if (( $''${#title} > 32 ))
            then
                title=$(echo $title | cut -b -30)...
            fi

            if (( $''${#artist} > 20 ))
            then
                artist=$(echo $artist | cut -b -18)...
            fi

            echo $title - $artist
          '';
        };
        volume_script = pkgs.writeTextFile {
          name = "volume";
          executable = true;
          text = ''
            case $button in
              1)
                ${pkgs.spotifython-cli}/bin/spotifython-cli prev ;;
              2)
                ${pkgs.spotifython-cli}/bin/spotifython-cli play-pause ;;
              3)
                ${pkgs.spotifython-cli}/bin/spotifython-cli next ;;
              4)
                ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+ ;;
              5)
                ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%- ;;
            esac

            ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf("%d%%\n", $2*100)}'
          '';
        };
        iface_script = pkgs.writeTextFile {
          name = "iface";
          executable = true;
          text = ''
            IF="$(ip route | awk '/^default/ { print $5 ; exit }')"

            if [[ "$IF" = "" ]] || [[ "$(cat /sys/class/net/$IF/operstate)" = 'down' ]]; then
              exit
              echo "down" # full text
              echo "down" # short text
              echo #FF0000 # color
              exit
            fi

            # if no interface is found, use the first device with a global scope
            IPADDR=$(ip addr show $IF | perl -n -e "/inet ([^ \/]+).* scope global/ && print \$1 and exit")

            # try to guess the wifi name
            if command -v iw > /dev/null && iw $IF info > /dev/null 2>&1;
            then
              echo "$IF: $IPADDR ($(iw $IF info | grep -Po '(?<=ssid ).*' | tr -d " \t\n\r"))"
            else
              echo "$IF: $IPADDR"
            fi
          '';
        };
        bandwidth_script = pkgs.writeTextFile {
          name = "bandwidth";
          executable = true;
          text = ''
            function default_interface {
              ip route|awk '/^default via/ {print $5; exit}'
            }

            if [ ! -f "/proc/net/dev" ]; then
              echo "/proc/net/dev not found"
              exit 1
            fi

            iface=$(default_interface)

            while [ -z "$iface" ]; do
              echo No default gateway
              sleep 5
              iface=$(default_interface)
            done

            init_line=$(cat /proc/net/dev | grep "^[ ]*$iface:")
            init_received=$(awk '{print $2}' <<< $init_line)
            init_sent=$(awk '{print $10}' <<< $init_line)

            (while true; do cat /proc/net/dev; sleep 2; done) | \
              stdbuf -oL grep "^[ ]*$iface:" | \
              awk '
              BEGIN {old_received='"$init_received"';old_sent='"$init_sent"';}
              {
                 received=$2;
                 sent=$10;
                 rx=(received-old_received)/2024;
                 wx=(sent-old_sent)/2024;
                 old_received=received;
                 old_sent=sent;

                 if(rx>10240) {
                   printf("<span color=\"#FF7373\">");
                 } else if(rx>5120) {
                   printf("<span color=\"#FFA500\">");
                 } else {
                   printf("<span color=\"#00FF00\">");
                 }
                 if(rx>1000) {
                   printf("%5.1f Mb/s</span> ",rx/1024);
                 } else {
                   printf("%5.1f Kb/s</span> ",rx);
                 }

                 if(wx>5120) {
                   printf("<span color=\"#FF7373\">");
                 } else if(wx>2560) {
                   printf("<span color=\"#FFA500\">");
                 } else {
                   printf("<span color=\"#00FF00\">");
                 }
                 if(wx>1000) {
                   printf("%5.1f Mb/s</span>\n",wx/1024);
                 } else {
                   printf("%5.1f Kb/s</span>\n",wx);
                 }
                 fflush();
              }
              '
          '';
        };
        cpu_usage_script = pkgs.writeTextFile {
          name = "cpu_usage";
          executable = true;
          text = ''
            while true; do cat /proc/stat; sleep 1; done | awk '
            /^cpu / {
              used=$2+$3+$4+$7+$8+$9+$10+$11;
              total=used+$5+$6;
              pct=(used - old_used)/(total - old_total)*100;
              if(pct>90) {
                printf("{\"color\": \"#ff0000\",")
              } else if(pct>75) {
                printf("{\"color\": \"#ffa500\",")
              } else {
                printf("{")
              }
              printf("\"full_text\": \"%.0f%%\"}\n",pct);
              old_used=used;
              old_total=total;
              fflush();
            }' 
          '';
        };
        memory_script = pkgs.writeTextFile {
          name = "memory";
          executable = true;
          text = ''
            free --mega | awk '
            /^Mem:.*/ {
              total=$2/1024;
              used=$3/1024;
              free=$7/1024;
              exit
            }
            END {
              pct=used/total*100;
              if(pct>70) {
                printf("%.1fG\n", free)
              }
              else {
                printf("%.1fG\n", used)
              }
              if(pct>90) {
                print("#ff0000")
              } else if(pct>70) {
                print("#ffff00")
              }
            }'
          '';
        };
        disk_script = pkgs.writeTextFile {
          name = "disk";
          executable = true;
          text = ''
            df -h -P -l "$DIR" | awk '
            /\/.*/ {
              print $4;
              use=$5;
              exit
            }
            END {
              gsub(/%/,"",use);
              if(100-use < 10) {
                print "#ff0000"
              }
            }'
          '';
        };
      in {
        "mail" = {
          command = "${mail_script}";
          interval = 300;
          color = "#ff0000";
          signal = "12";
        };
        "spotify" = lib.hm.dag.entryAfter [ "mail" ] {
          command = "${spotify_script}";
          short_text = "󰝚";
          interval = 5;
          signal = "11";
        };
        "volume" = lib.hm.dag.entryAfter [ "spotify" ] {
          command = "${volume_script}";
          align = "right";
          interval = 10;
          signal = i3blocks_volume_signal;
        };
        "iface" = lib.hm.dag.entryAfter [ "volume" ] {
          command = "${iface_script}";
          short_text = " ";
          color = "#00FF00";
          interval = 10;
          separator = "false";
        };
        "bandwidth" = lib.hm.dag.entryAfter [ "iface" ] {
          command = "${bandwidth_script}";
          interval = "persist";
          markup = "pango";
        };
        "cpu" = lib.hm.dag.entryAfter [ "bandwidth" ] {
          command = "${cpu_usage_script}";
          interval = "persist";
          min_width = "100%";
          align = "right";
          format = "json";
        };
        "memory" = lib.hm.dag.entryAfter [ "cpu" ] {
          command = "${memory_script}";
          interval = 5;
        };
        "disk" = lib.hm.dag.entryAfter [ "memory" ] {
          command = "${disk_script}";
          DIR = "/";
          interval = 10;
        };
        "time" = lib.hm.dag.entryAfter [ "disk" ] {
          command = "date '+%d.%m.%4Y %T'";
          interval = 1;
        };
      };
    };
  };
}
