{ pkgs, lib, ... }: {
  imports = [ ../common ];

  home.persistence = lib.mkForce { };
  sops.secrets = lib.mkForce { };

  home.packages = with pkgs; [ age ssh-to-age ];

  desktop.enable = true;
  wayland.windowManager.sway.enable = true;

  programs = {
    waybar.enable = true;

    discord.enable = false;
    neomutt.enable = false;
    khard.enable = false;
    khal.enable = false;
    spotifython-cli.enable = false;

    zsh.promptColor = "green";
    ssh.matchBlocks."nyx" = {
      host = "nyx home.vaw-valentin.de";
      hostname = "home.vaw-valentin.de";
    };
  };
  services = {
    ntfy.enable = false;
    syncthing.enable = false;
  };
}
