_final: prev: {
  waybar = prev.waybar.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [
      ./fix-sway-workspaces-visible-class-doesn-t-work.patch
      ./hyprland-bar-scroll.patch
      ./sway-scroll.patch
      ./tray-service.patch
    ];
  });
}
