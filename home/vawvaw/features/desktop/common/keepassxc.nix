{ pkgs, ... }:
{
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

  home.persistence."/local_persist/home/vawvaw" = {
    directories = [
      ".config/keepassxc"
      ".cache/keepassxc"
    ];
  };
}
