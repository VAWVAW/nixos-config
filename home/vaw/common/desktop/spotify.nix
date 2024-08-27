{ config, pkgs, lib, ... }: {

  options.programs.spotify.enable =
    lib.mkEnableOption "spotify proprietary client";

  options.programs.spotifython-cli.enable =
    lib.mkEnableOption "spotifython-cli";

  config = lib.mkMerge [
    (lib.mkIf config.programs.spotify.enable {
      home.packages = with pkgs; [ spotifython-cli ];

      home.persistence."/persist/home/vaw".directories = [
        {
          directory = ".config/spotify";
          method = "symlink";
        }
        {
          directory = ".cache/spotify";
          method = "symlink";
        }
      ];

      programs.firejail.wrappedBinaries."spotify" = {
        executable = "${pkgs.spotify}/bin/spotify";
        profile = "${pkgs.firejail}/etc/firejail/spotify.profile";
      };
    })

    (lib.mkIf config.programs.spotifython-cli.enable {
      home.packages = with pkgs; [ spotifython-cli ];

      home.persistence."/persist/home/vaw".directories = [{
        directory = ".cache/spotifython-cli";
        method = "symlink";
      }];

      sops.secrets."spotifython-client_secret" = { };

      xdg.configFile."spotifython-cli/config" = {
        source = (pkgs.formats.ini { }).generate "spotifython-cli-config.ini" {
          Authentication = {
            client_id = "b6e7024948814d9b9c795f2aa188dca5";
            client_secret_command = "${pkgs.coreutils-full}/bin/cat ${
                config.sops.secrets."spotifython-client_secret".path
              }";
          };
          interface.dmenu_cmdline =
            "${pkgs.bemenu}/bin/bemenu -i -l {lines} -m 1 -p {prompt}";
        };
      };
    })

    (lib.mkIf config.services.spotifyd.enable {
      home.packages = with pkgs; [ playerctl ];

      home.persistence."/persist/home/vaw".directories = [{
        directory = ".local/share/spotifyd";
        method = "symlink";
      }];

      systemd.user.services.spotifyd.Unit.After =
        [ "sops-nix.service" "network-online.target" ];

      services.spotifyd = {
        package = pkgs.spotifyd.override { withMpris = true; };
        settings = let
          cache_path = "${config.xdg.dataHome}/spotifyd";
          on_song_change_hook = pkgs.writeShellScript "spotifyd-song-change" ''
            if [ "$PLAYER_EVENT" != "play" ]; then
              exit
            fi

            IFS=';' read -r TITLE DESC URL <<< $(${pkgs.playerctl}/bin/playerctl -p spotifyd -f '{{xesam:title}};{{xesam:artist}} - {{xesam:album}};{{mpris:artUrl}}' metadata)

            IMAGE_NAME=$(echo $URL | cut -d'/' -f5)

            mkdir -p -m 700 /tmp/spotify-icons
            FILE_NAME="/tmp/spotify-icons/$IMAGE_NAME"

            if [ ! -f $FILE_NAME ]; then 
              ${pkgs.curl}/bin/curl -o $FILE_NAME $URL 2>/dev/null
            fi

            ${pkgs.libnotify}/bin/notify-send --app-name=spotifyd --icon=$FILE_NAME "$TITLE" "$DESC"
          '';
        in {
          global = {
            inherit on_song_change_hook cache_path;

            username_cmd =
              "${pkgs.jq}/bin/jq -r .username '${cache_path}/credentials.json'";
            backend = "alsa";
            device = "default";
            mixer = "PCM";
            volume_controller = "alsa";
            device_name = lib.mkDefault "vaw_spotifyd";
            bitrate = 160;
            no_audio_cache = false;
            initial_volume = "0";
            volume_normalisation = true;
            normalisation_pregain = -15;
            autoplay = false;
            zeroconf_port = 2575;
            device_type = "computer";
          };
        };
      };
    })
  ];
}
