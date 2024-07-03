{
  imports = [ ../common ];
  programs.zsh = {
    promptColor = "yellow";
    startTmux = true;
  };
  home.shellAliases = {
    nswitch =
      "sudo nixos-rebuild switch --flake /var/lib/syncthing/data/Documents/nixos-config#";
    nboot =
      "sudo nixos-rebuild boot --flake /var/lib/syncthing/data/Documents/nixos-config#";
    ntest =
      "sudo nixos-rebuild test --flake /var/lib/syncthing/data/Documents/nixos-config#";
  };
}
