{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell { buildInputs = with pkgs; [ nil nixfmt-classic statix deadnix ]; }
