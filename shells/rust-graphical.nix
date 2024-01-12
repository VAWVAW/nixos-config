{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:
pkgs.mkShell rec {
  buildInputs = (import ./rust.nix { }).buildInputs ++ (with pkgs; [
    libxkbcommon
    libGL
    vulkan-loader
    libz.dev

    # WINIT_UNIX_BACKEND=wayland
    wayland

    # WINIT_UNIX_BACKEND=x11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11

  ]);

  LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
}
