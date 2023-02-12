{
  imports = [
    ./features/desktop/sway
    ./global.nix
  ];

  services.spotifyd.settings.global.device_name = "vaw-pc_spotifyd";
}
