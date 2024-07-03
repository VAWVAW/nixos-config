{ pkgs, ... }: {
  imports = [ ../common ];

  programs.zsh.promptColor = "green";

  home.packages = with pkgs;
    [ sops psmisc age ssh-to-age ] ++ (import ../../../shells/default.nix {
      inherit pkgs;
    }).nixos-config.buildInputs;

}
