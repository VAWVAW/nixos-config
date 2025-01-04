{
  wrapFirejailBinary = { name ? "firejail-wrapped",
    # path of the suid binary installed via package manager (on nixos that is '/run/wrappers/bin/firejail')
    firejailBinary ? "/run/wrappers/bin/firejail",
    # path to executable to run sandboxed
    wrappedExecutable,
    # firejail profile to use
    profile ? null,
    # extra arguments to pass to firejail
    extraArgs ? [ ],
    # nix package set to use for builder
    pkgs, lib ? pkgs.lib }:
    let
      args = lib.escapeShellArgs
        (extraArgs ++ lib.optional (profile != null) "--profile=${profile}");
    in pkgs.writeShellScriptBin name ''
      exec ${firejailBinary} ${args} ${wrappedExecutable} "$@"
    '';
}
