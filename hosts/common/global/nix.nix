{ inputs, config, lib, ... }: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };

    # Add each flake input as a registry
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Map registries to channels
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;
  };
}
