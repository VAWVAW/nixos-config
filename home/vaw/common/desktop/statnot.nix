{ config, pkgs, ... }:
let
  config_file = pkgs.writeText "statnot-config.py" ''
    DEFAULT_NOTIFY_TIMEOUT = 1
    MAX_NOTIFY_TIMEOUT = 1

    USE_STATUSTEXT = False
    QUEUE_NOTIFICATIONS = False

    import os
    def update_text(text, app_name=""):
      if app_name != "":
        app_name = f"{app_name}: "
        padding = " " * len(app_name)
      lines = text.strip().split("\n")

      for name in [f"/dev/tty{i}" for i in range(13)] + [f"/dev/pts/{i}" for i in os.listdir("/dev/pts") if i != "ptmx"]:
        try:
          with open(name, "w") as out:
            out.write("\n".join(["", f"\033[2m{app_name}\033[0m\033[1m{lines[0]}\033[0m"] + [f"{padding}\033[2m{line}\033[0m" for line in lines] + [""]))
        except PermissionError:
          pass

      print("")
      print(f"\033[2m{app_name}\033[0m\033[1m{lines[0]}\033[0m")
      for line in lines[1:]:
        print(f"{padding}\033[2m{line}\033[0m")
      print("")

      os.system(f'DUNST_APP_NAME="{app_name}" ${config.services.dunst.settings.play_sound.script}')
  '';
in { services.statnot.configFile = config_file; }
