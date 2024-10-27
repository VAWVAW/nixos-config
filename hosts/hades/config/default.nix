{
  imports = [ ./arduino.nix ./binary-cache.nix ./network.nix ./nvidia.nix ];
  programs.adb.enable = true;
  services.ratbagd.enable = true;
}
