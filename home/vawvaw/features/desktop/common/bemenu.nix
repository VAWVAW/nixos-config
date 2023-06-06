{ pkgs, lib, config, ... }: {
  home.packages = with pkgs; [ bemenu ];
  home.sessionVariables = {
    BEMENU_OPTS = "--hf=#ffffff --hb=#005577 --tf=#ffffff --tb=#005577";
    BEMENU_BACKEND = if (!config.gtk.enable) then "curses" else "";
  };
}
