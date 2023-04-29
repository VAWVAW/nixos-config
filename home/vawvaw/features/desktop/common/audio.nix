{ pkgs, ... }:
{
  home.packages = with pkgs;[
    wireplumber
    noisetorch
    pavucontrol
    (writeScriptBin "set-volume" "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ $1")
  ];
}
