{ pkgs, ... }:
# simple cli matrix client
{
  home.packages = with pkgs; [ iamb ];
  home.persistence."/persist/home/vawvaw" = {
    directories = [ ".config/iamb/profiles" ];
  };

  xdg.configFile."iamb/config.json".text = builtins.toJSON {
    "default_profile" = "vaw-valentin.de";
    "profiles" = {
      "vaw-valentin.de" = {
        "url" = "https://matrix.vaw-valentin.de";
        "user_id" = "@vawvaw:vaw-valentin.de";
      };
      "matrix.org" = {
        "url" = "https://matrix.org";
        "user_id" = "@vawvaw:matrix.org";
      };
    };
  };
}