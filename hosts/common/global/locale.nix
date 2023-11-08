{ lib, ... }: {
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales =
      lib.mkDefault [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
  };
  time.timeZone = lib.mkDefault "Europe/Berlin";

  console = { useXkbConfig = true; };
  services.xserver = {
    layout = lib.mkDefault "de";
    xkbVariant = lib.mkDefault "us";
    xkbOptions = lib.mkDefault "altwin:swap_lalt_lwin,caps:escape,ctrl:menu_rctrl,ctrl:swap_rwin_rctl";
  };
}
