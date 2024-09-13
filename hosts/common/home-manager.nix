{ inputs, outputs, config, ... }: {
  environment.pathsToLink =
    [ "/share/xdg-desktop-portal" "/share/applications" ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      nvim =
        outputs.packages."${config.nixpkgs.hostPlatform.system}".nixvim-all;
    };
  };
}
