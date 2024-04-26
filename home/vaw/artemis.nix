{
  imports = [ ./global.nix ];
  programs.zsh = {
    promptColor = "yellow";
    startTmux = true;
  };
  home.shellAliases = {
    nswitch =
      "sudo nixos-rebuild switch --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    nboot =
      "sudo nixos-rebuild boot --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    nbuild =
      "nixos-rebuild build --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    ntest =
      "sudo nixos-rebuild test --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    hswitch =
      "home-manager switch --flake /var/lib/syncthing/data/Documents/nixos-config";

  };
}
