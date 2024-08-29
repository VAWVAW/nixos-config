{ inputs, outputs, config, ... }: {
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      platform = config.nixpkgs.hostPlatform.system;
    };
  };
}
