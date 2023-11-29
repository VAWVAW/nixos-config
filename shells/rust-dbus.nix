{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = (import ./rust.nix { }).buildInputs ++ (with pkgs; [ dbus ]);
}
