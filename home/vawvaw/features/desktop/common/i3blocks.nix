{ pkgs, config, ... }: {
  sops.secrets = { divera-token = { }; };

  programs.i3blocks = let i3blocks_volume_signal = "10";
  in {
    enable = true;
    # scripts are derived from https://github.com/vivien/i3blocks-contrib
    blocks = let
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
              ${pkgs.spotifython-cli}/bin/spotifython-cli previous ;;
            2)
              ${pkgs.spotifython-cli}/bin/spotifython-cli play-pause -c ;;
            3)
              ${pkgs.spotifython-cli}/bin/spotifython-cli next ;;
            4)
              ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+; pkill -SIGRTMIN+${i3blocks_volume_signal} i3blocks ;;
            5)
              ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-; pkill -SIGRTMIN+${i3blocks_volume_signal} i3blocks ;;
          esac

          metadata=$(${pkgs.spotifython-cli}/bin/spotifython-cli metadata -c -j title artist_name is_playing)

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
              ${pkgs.spotifython-cli}/bin/spotifython-cli previous ;;
            2)
              ${pkgs.spotifython-cli}/bin/spotifython-cli play-pause -c ;;
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
      battery_script = pkgs.writeTextFile {
        name = "battery";
        executable = true;
        text = ''
          bat_name="${config.battery.name}"

          infos=$(${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_$bat_name | grep -E "(time|percentage)"| cut -c26- |sed -E "s/ (.).+/\1/g")

          percentage=$(echo $infos | cut -d " " -f2 | sed -E "s/%//")
          time_left=$(echo $infos | cut -d " " -f1)

          echo "$percentage% ($time_left)"
          echo "$percentage% ($time_left)"

          if [ $percentage -ge 30 ] ; then
            echo "#00ff00"
            exit
          fi

          if [ $percentage -lt 30 ] ; then
            echo "#ffff00"
          fi

          if [ $percentage -lt 15 ] ; then
            echo "#ff0000"
          fi
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
    in [
      {
        name = "divera";
        command = ''
          ${pkgs.divera-status}/bin/divera-status -f $XDG_RUNTIME_DIR/secrets/divera-token -s 800,801,802 -o 804,802,801,800 -e -d "{{\"full_text\":\"{full_text} <span color=\\\"#{status_color}\\\">◼</span>\", \"short_text\":\"{short_text}\"}}"'';
        interval = "persist";
        format = "json";
        markup = "pango";
      }
      {
        name = "mail";
        command = "${mail_script}";
        interval = 300;
        color = "#ff0000";
        signal = "12";
      }
      {
        name = "spotify";
        command = "${spotify_script}";
        short_text = "󰝚";
        interval = 5;
        signal = "11";
      }
      {
        name = "volume";
        command = "${volume_script}";
        align = "right";
        interval = 10;
        signal = i3blocks_volume_signal;
      }
      {
        name = "iface";
        command = "${iface_script}";
        short_text = " ";
        color = "#00FF00";
        interval = 10;
        separator = "false";
      }
      {
        name = "bandwidth";
        command = "${bandwidth_script}";
        interval = "persist";
        markup = "pango";
      }
      {
        name = "cpu_usage";
        command = "${cpu_usage_script}";
        interval = "persist";
        min_width = "100%";
        align = "right";
        format = "json";
      }
      {
        name = "battery";
        command =
          if config.battery.enable then "${battery_script}" else "echo ''";
        interval = 15;
      }
      {
        name = "memory";
        command = "${memory_script}";
        interval = 5;
      }
      {
        name = "disk_root";
        command = "${disk_script}";
        DIR = "/";
        interval = 10;
      }
      {
        name = "time";
        command = "date '+%d.%m.%4Y %T'";
        interval = 1;
      }
    ];
  };
}
