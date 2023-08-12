{ config, ... }: {
  home.persistence."/persist/home/vawvaw" = {
    directories =
      [ ".config/JetBrains" ".cache/JetBrains" ".local/share/JetBrains" ];
  };
  home.file.".ideavimrc".text = config.programs.vim.extraConfig;
}
