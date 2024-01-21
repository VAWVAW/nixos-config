{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:
pkgs.mkShell rec {
  buildInputs = (import ./rust.nix { }).buildInputs ++ (with pkgs; [
    libxkbcommon
    expat
    freetype
    freetype.dev
    libGL

    vulkan-loader
    vulkan-tools
    vulkan-headers

    libz

    # WINIT_UNIX_BACKEND=wayland
    wayland
    wayland-protocols

    # WINIT_UNIX_BACKEND=x11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11

    gperf
  ]);

  LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
}
