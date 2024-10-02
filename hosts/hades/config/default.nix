{
  imports =
    [ ./arduino.nix ./binary-cache.nix ./network.nix ./nvidia.nix ./ovmf.nix ];
  programs.adb.enable = true;
  services.ratbagd.enable = true;
}
