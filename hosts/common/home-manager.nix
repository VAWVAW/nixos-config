{ inputs, outputs, nvim, ... }: {
  environment.pathsToLink =
    [ "/share/xdg-desktop-portal" "/share/applications" ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs nvim; };
  };
}
