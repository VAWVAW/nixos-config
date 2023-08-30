{
  environment.etc."resolv.conf".text = ''
    nameserver 192.168.2.1
    options edns0
  '';

  system.stateVersion = "23.05";
}
