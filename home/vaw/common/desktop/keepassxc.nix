{ outputs, config, pkgs, lib, ... }:
let cfg = config.programs.keepassxc;
in {
  options.programs.keepassxc.enable = lib.mkEnableOption "keepassxc";

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/vaw".directories = [
      {
        directory = ".config/keepassxc";
        method = "symlink";
      }
      {
        directory = ".cache/keepassxc";
        method = "symlink";
      }
    ];

    home.packages = [
      (outputs.lib.wrapFirejailBinary {
        inherit pkgs lib;
        name = "keepassxc";
        wrappedExecutable = "${pkgs.keepassxc}/bin/keepassxc";
        profile = "${pkgs.firejail}/etc/firejail/keepassxc.profile";
        extraArgs = [
          # U2F USB stick
          "--ignore=private-dev"
          "--ignore=nou2f"
          "--protocol=netlink,unix"
        ];
      })
    ];
  };
}
