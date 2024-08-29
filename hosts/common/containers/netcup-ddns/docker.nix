{ pkgs ? import <nixpkgs> { }, ... }:

let package = pkgs.callPackage ./app { inherit pkgs; };
in pkgs.dockerTools.buildImage {
  name = "netcup-dynamic-dns";
  tag = "latest";

  copyToRoot = with pkgs; [
    (buildEnv {
      name = "image-root";
      paths = [ package ];
      pathsToLink = [ "/bin" ];
    })
    dockerTools.caCertificates
  ];

  config = {
    Cmd = [ "/bin/netcup-ddns" "--config" "/config/config.php" ];
    Volumes = { "/config" = { }; };
  };
}
