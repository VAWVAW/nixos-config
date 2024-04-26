{ pkgs, ... }: {
  programs.firejail.wrappedBinaries = {
    tor-browser = {
      executable = "${pkgs.tor-browser-bundle-bin}/bin/tor-browser";
      profile = "${pkgs.firejail}/etc/firejail/tor-browser.profile";
    };
  };
}
