{ pkgs, config, lib, ... }: {
  imports = [
    ./sway.nix

    ../common
    ../common/audio.nix
    ../common/i3blocks.nix
    ../common/dunst.nix
  ];

  programs.swaylock = {
    enable = true;
    settings = {
      ignore-empty-password = true;

      color = "000000";
      indicator-caps-lock = true;
      indicator-idle-visible = true;
      inside-color = "0000ff";
    };
  };
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ] ++ lib.optionals config.services.spotifyd.enable [{
      event = "after-resume";
      command = "${pkgs.systemd}/bin/systemctl --user restart spotifyd.service";
    }];
    timeouts = [
      {
        timeout = 900;
        command = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
      }
    ];
  };
}
