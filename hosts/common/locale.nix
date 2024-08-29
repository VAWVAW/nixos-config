{ lib, ... }: {
  i18n = {
    defaultLocale = lib.mkDefault "en_IE.UTF-8";
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
      "en_IE.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };
  time.timeZone = lib.mkDefault "Europe/Berlin";

  console.useXkbConfig = true;
  services.xserver = {
    xkb = {
      layout = lib.mkDefault "de";
      variant = lib.mkDefault "us";
      options = lib.mkDefault
        "altwin:swap_lalt_lwin,caps:escape,ctrl:menu_rctrl,ctrl:swap_rwin_rctl,custom:qwertz_y_z";
    };
  };
}
