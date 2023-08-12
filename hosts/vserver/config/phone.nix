{ pkgs, ... }: {
  environment.persistence."/backed_up" = {
    directories = [ "/home/phone/data" ];
  };

  users.users.phone = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      ''
        command="${pkgs.rrsync}/bin/rrsync /home/phone/" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3hHgB96sdq0zQZXcC5cLbOeEwYV2sm6Lpo3DrxbpeN''
    ];
  };
}
