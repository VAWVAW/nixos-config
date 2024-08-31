{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = (import ./rust.nix { inherit pkgs; }).buildInputs
    ++ (with pkgs; [ dbus ]);
}
