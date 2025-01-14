{ inputs, config, lib, ... }: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };

    # Add each flake input as a registry
    registry = (lib.mapAttrs (_: value: { flake = value; }) inputs) // {
      pkgs.flake = inputs."nixpkgs";
    };

    # Map registries to channels
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      trusted-public-keys = [
        # hades
        "cache.vaw-valentin.de:/8iA2reUED51lB6NGBfgwI5a1u1NCru1kL9BDKEdCjY="
        # zeus
        "zeus:iDYlA1HbAwIw3XqhMqPjCG2ihP7LLV0g16Gs9WPxfpU="
        # artemis
        "server.vaw-valentin.de:1Lm+b+ZWUwbV8N4nazbdjZpn4ifYidBE7Jg9KI7DTt0="
      ];
      trusted-substituters = [ "http://192.168.2.10:5000" ];
    };
  };
}
