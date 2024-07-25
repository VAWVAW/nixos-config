{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs;
    let
      nbuild = hostName:
        (writeShellScriptBin "nbuild-${hostName}"
          "nixos-rebuild build --flake .#${hostName} $@");
      ntest = hostName:
        (writeShellScriptBin "ntest-${hostName}"
          "nixos-rebuild test --flake .#${hostName} --use-remote-sudo --target-host ${hostName} $@");
      nswitch = hostName:
        (writeShellScriptBin "nswitch-${hostName}"
          "nixos-rebuild switch --flake .#${hostName} --use-remote-sudo --target-host ${hostName} $@");
      nboot = hostName:
        (writeShellScriptBin "nboot-${hostName}"
          "nixos-rebuild boot --flake .#${hostName} --use-remote-sudo --target-host ${hostName} $@");
    in [
      (writeShellScriptBin "nbuild" "nixos-rebuild build --flake .# $@")
      (writeShellScriptBin "ntest" "sudo nixos-rebuild test --flake .# $@")
      (writeShellScriptBin "nswitch" "sudo nixos-rebuild switch --flake .# $@")
      (writeShellScriptBin "nboot" "sudo nixos-rebuild boot --flake .# $@")
      (writeShellScriptBin "hswitch" "home-manager switch --flake . $@")

      (nbuild "artemis")
      (ntest "artemis")
      (nswitch "artemis")
      (nboot "artemis")

      (nbuild "nyx")
      (ntest "nyx")
      (nswitch "nyx")
      (nboot "nyx")

      (nbuild "zeus")
    ];
}
