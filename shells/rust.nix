{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer

    # debugging
    lldb

    # common dependencies
    pkg-config
    cmake
    openssl
    fontconfig
  ];
}
