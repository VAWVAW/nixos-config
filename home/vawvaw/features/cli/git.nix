{
  programs.git = {
    enable = true;
    userEmail = "valentin@wiedekind1.de";
    userName = "vawvaw";
    aliases = {
      a = "add -A";
      ca = "commit -a";
      graph = "log --decorate --oneline --graph";
    };
    signing = {
      key = "508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      diff = {
        tool = "vimdiff";
        mnemonicprefix = true;
      };
    };
    ignores = [ "*~" "*.swp" "result" ];
  };
}
