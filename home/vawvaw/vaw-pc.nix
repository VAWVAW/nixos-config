{
  imports = [
    ./global.nix

    ./features/desktop/sway
    ./features/desktop/common/steam.nix
  ];

  services.spotifyd.settings.global.device_name = "vaw-pc_spotifyd";
}
