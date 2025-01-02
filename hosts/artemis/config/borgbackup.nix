{ inputs, config, ... }: {
  sops.secrets."artemis-borg" = {
    format = "binary";
    sopsFile = "${inputs.self}/secrets/artemis-borg";
  };

  services.borgbackup = {
    repos."local" = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDW8KqMDzTeIuvDoPa/8JnQMpIkN/7W/w3k5CInO8u/4 artemis-borg"
      ];
    };

    jobs."local" = {
      repo = config.services.borgbackup.repos."local".path;
      encryption.mode = "none";
      backupSnapshot = true;
    };
    jobs."remote-nyx" = {
      repo = "borg@home.vaw-valentin.de:.";
      encryption.mode = "none";
      backupSnapshot = true;
      sshKey = config.sops.secrets."artemis-borg".path;
    };
  };
}
