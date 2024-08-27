{
  imports = [ ./bluetooth.nix ./pipewire.nix ./fonts.nix ./xdg.nix ];

  programs.dconf.enable = true;

  security.pam.services.swaylock = { };
  security.pam.services.hyprlock = { };

  programs.firejail.enable = true;

  hardware.opengl.enable = true;
}
