{ inputs, outputs, ... }: {
  environment.pathsToLink =
    [ "/share/xdg-desktop-portal" "/share/applications" ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };
}
