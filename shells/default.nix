{ pkgs, ... }: rec {
  rust = pkgs.mkShell {
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
  };
  nix = pkgs.mkShell { buildInputs = with pkgs; [ nil nixfmt statix ]; };
  lua = pkgs.mkShell { buildInputs = with pkgs; [ lua-language-server ]; };
  nixos-config =
    pkgs.mkShell { buildInputs = nix.buildInputs ++ lua.buildInputs; };
  python = pkgs.mkShell {
    buildInputs = with pkgs; [ python311 python311Packages.pip pyright ];
  };
}
