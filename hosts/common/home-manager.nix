{ inputs, outputs, config, pkgs-stable, nvim, ... }: {
  environment.pathsToLink =
    [ "/share/xdg-desktop-portal" "/share/applications" ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs nvim pkgs-stable;
      hostname = config.networking.hostName;
    };
  };
}
