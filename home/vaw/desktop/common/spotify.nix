{ pkgs, lib, config, ... }:
let
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
  imports = [ ./bemenu.nix ];

  home.packages = with pkgs; [ playerctl spotifython-cli ];

  home.persistence."/persist/home/vaw" = {
    directories = [
      {
        directory = ".cache/spotifython-cli";
        method = "symlink";
      }
      {
        directory = ".local/share/spotifyd";
        method = "symlink";
      }
    ];
  };

  sops.secrets = {
    "spotify-password" = { };
    "spotifython-client_secret" = { };
  };

  xdg.configFile."spotifython-cli/config" = {
    source = (pkgs.formats.ini { }).generate "spotifython-cli-config.ini" {
      Authentication = {
        client_id = "b6e7024948814d9b9c795f2aa188dca5";
        client_secret_command = "${pkgs.coreutils-full}/bin/cat ${
            config.sops.secrets."spotifython-client_secret".path
          }";
      };
      spotifyd.notify = true;
      interface.dmenu_cmdline =
        "${pkgs.bemenu}/bin/bemenu -i -l {lines} -m 1 -p {prompt}";
    };
  };

  systemd.user.services.spotifyd.Unit.After =
    [ "sops-nix.service" "network-online.target" ];

  services.spotifyd = let
  cache_path = "${config.xdg.dataHome}/spotifyd";
  in{
    enable = true;
    package = pkgs.spotifyd.override { withMpris = true; };
    settings = {
      global = {
        inherit on_song_change_hook cache_path;

        username_cmd = "${pkgs.jq}/bin/jq -r .username '${cache_path}/credentials.json'";
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
}
