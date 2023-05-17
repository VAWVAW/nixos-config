{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "monospace";
          style = "Regular";
        };
        bold = {
          family = "monospace";
          style = "Bold";
        };
        italic = {
          family = "monospace";
          style = "Italic";
        };
        bold_italic = {
          family = "monospace";
          style = "Bold Italic";
        };
        size = 10.0;
      };
      colors = {
        primary = {
          background = "#050505";
          foreground = "#ffffff";
        };
        normal = {
          black = "#000000";
          red = "#c21818";
          green = "#48c092";
          yellow = "#ff9f05";
          blue = "#3333ff";
          magenta = "#7c00b2";
          cyan = "#18b2b2";
          white = "#b2b2b2";
        };
        bright = {
          black = "#686868";
          red = "#ff0000";
          green = "#0077ff";
          yellow = "#2222ff";
          blue = "#3737ff";
          magenta = "#ff54ff";
          cyan = "#54ffff";
          white = "#ffffff";
        };
        dim = {
          black = "#181818";
          red = "#650000";
          green = "#006500";
          yellow = "#655e00";
          blue = "#000065";
          magenta = "#650065";
          cyan = "#006565";
          white = "#656565";
        };
      };
      key_bindings = [
        { key = "Return"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
      ];
    };
  };
}
