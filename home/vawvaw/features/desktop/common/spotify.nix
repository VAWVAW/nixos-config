{ pkgs, lib, config, ... }:
{
  imports = [
    ./bemenu.nix
  ];

  home.packages = with pkgs; [
    playerctl
    spotify-tui
    spotifython-cli
  ];

  home.persistence."/local_persist/home/vawvaw" = {
    directories = [
      ".config/spotify-tui"
      ".cache/spotify-tui"
      ".cache/spotifython-cli"
      ".local/share/spotifyd"
    ];
  };

  sops.secrets = {
    spotify-password = { };
    spotifython-client_secret = { };
  };

  xdg.configFile."spotifython-cli/config" = {
    source = (pkgs.formats.ini { }).generate "spotifython-cli-config.ini" {
      Authentication = {
        client_id = "b6e7024948814d9b9c795f2aa188dca5";
        client_secret_command = "${pkgs.coreutils-full}/bin/cat $XDG_RUNTIME_DIR/secrets/spotifython-client_secret";
      };
      spotifyd.notify = true;
      interface.dmenu_cmdline = "${pkgs.bemenu}/bin/bemenu -i -l 50 -m 1 -p {prompt}";
    };
  };

  systemd.user.services.spotifyd.Unit.After = [ "sops-nix.service" ];

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override { withMpris = true; };
    settings = {
      global = {
        username = "vaw.valentin@gmx.de";
        password_cmd = "${pkgs.coreutils-full}/bin/cat $XDG_RUNTIME_DIR/secrets/spotify-password";
        backend = "alsa";
        device = "default";
        mixer = "PCM";
        volume_controller = "alsa";
        on_song_change_hook = "${pkgs.spotifython-cli}/bin/spotifython-cli spotifyd";
        device_name = lib.mkDefault "vawvaw_sptifyd";
        bitrate = 160;
        cache_path = "${config.xdg.dataHome}/spotifyd";
        no_audio_cache = false;
        initial_volume = "0";
        volume_normalisation = true;
        normalisation_pregain = -21;
        autoplay = false;
        zeroconf_port = 2575;
        device_type = "computer";
      };
    };
  };
}
