{ pkgs, ... }: {
  home.persistence."/persist/home/vawvaw".directories = [
    {
      directory = ".config/keepassxc";
      method = "symlink";
    }
    {
      directory = ".cache/keepassxc";
      method = "symlink";
    }
  ];

  programs.firejail.wrappedBinaries = {
    keepassxc = {
      executable = "${pkgs.keepassxc}/bin/keepassxc";
      profile = "${pkgs.firejail}/etc/firejail/keepassxc.profile";
      extraArgs = [
        # U2F USB stick
        "--ignore=private-dev"
        "--ignore=nou2f"
        "--protocol=netlink,unix"
      ];
    };
  };
}
