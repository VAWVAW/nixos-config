{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.sops-nix.homeManagerModule

    ./common
  ];

  sops = {
    age.keyFile = "/persist/home/vaw/.config/key.txt";
    defaultSopsFile = ../../../secrets/desktop.yaml;
  };

  home.persistence."/persist/home/vaw" = {
    allowOther = true;
    directories = [
      {
        directory = "Pictures";
        method = "symlink";
      }
      {
        directory = "Games";
        method = "symlink";
      }
      {
        directory = "Documents";
        method = "symlink";
      }
      {
        directory = "Downloads";
        method = "symlink";
      }
      {
        directory = ".cargo";
        method = "symlink";
      }
      {
        directory = ".rustup";
        method = "symlink";
      }
    ];
  };

}
