{ pkgs, ... }: {
  lua = import ./lua.nix { inherit pkgs; };
  nix = import ./nix.nix { inherit pkgs; };
  python = import ./python.nix { inherit pkgs; };
  rust = import ./rust.nix { inherit pkgs; };
  rust-dbus = import ./rust-dbus.nix { inherit pkgs; };
  rust-graphical = import ./rust-graphical.nix { inherit pkgs; };
  scala = import ./scala.nix { inherit pkgs; };
}
