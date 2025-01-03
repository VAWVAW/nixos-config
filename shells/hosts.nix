{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs;
    let
      nbuild = hostName: extraArgs:
        (writeShellScriptBin "nbuild-${hostName}"
          "nixos-rebuild build --flake .#${hostName} ${extraArgs} $@");
      ntest = hostName: extraArgs:
        (writeShellScriptBin "ntest-${hostName}"
          "nixos-rebuild test --flake .#${hostName} ${extraArgs} --target-host root@${hostName} $@");
      nswitch = hostName: extraArgs:
        (writeShellScriptBin "nswitch-${hostName}"
          "nixos-rebuild switch --flake .#${hostName} ${extraArgs} --target-host root@${hostName} $@");
      nboot = hostName: extraArgs:
        (writeShellScriptBin "nboot-${hostName}"
          "nixos-rebuild boot --flake .#${hostName} ${extraArgs} --target-host root@${hostName} $@");
    in [
      (writeShellScriptBin "nbuild" "nixos-rebuild build --flake .# $@")
      (writeShellScriptBin "ntest" "sudo nixos-rebuild test --flake .# $@")
      (writeShellScriptBin "nswitch" "sudo nixos-rebuild switch --flake .# $@")
      (writeShellScriptBin "nboot" "sudo nixos-rebuild boot --flake .# $@")
      (writeShellScriptBin "hswitch" "home-manager switch --flake . $@")

      (nbuild "artemis" "--use-substitutes --build-host artemis")
      (ntest "artemis" "--use-substitutes")
      (nswitch "artemis" "--use-substitutes")
      (nboot "artemis" "--use-substitutes")

      (nbuild "nyx" "--use-substitutes --build-host artemis")
      (ntest "nyx" "--build-host artemis")
      (nswitch "nyx" "--build-host artemis")
      (nboot "nyx" "--build-host artemis")

      (nbuild "zeus" "")
    ];
}
