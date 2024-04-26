{ config, ... }: {
  home.persistence."/persist/home/vaw".directories = [
    {
      directory = ".config/JetBrains";
      method = "symlink";
    }
    {
      directory = ".cache/JetBrains";
      method = "symlink";
    }
    {
      directory = ".local/share/JetBrains";
      method = "symlink";
    }
  ];
  home.file.".ideavimrc".text = config.programs.vim.extraConfig;
}
