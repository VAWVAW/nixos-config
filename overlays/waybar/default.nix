_final: prev: {
  waybar = prev.waybar.overrideAttrs (o: {
    patches = (o.patches or [ ])
      ++ [ ./hyprland-bar-scroll.patch ./tray-service.patch ];
  });
}
