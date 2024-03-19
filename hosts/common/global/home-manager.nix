{ inputs, outputs, config, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      platform = config.nixpkgs.hostPlatform.system;
    };
  };
}
