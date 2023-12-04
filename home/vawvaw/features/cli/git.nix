{
  programs.git = {
    enable = true;
    userEmail = "valentin@wiedekind1.de";
    userName = "vawvaw";
    aliases = {
      a = "add -A";
      ca = "commit -a";
      graph = "graph-branch --all";
      graph-branch =
        "log --graph --abbrev-commit --decorate=short --format=format:'%C(bold cyan)%h%C(reset) - %C(yellow)(%ar)%C(reset) %C(brightwhite)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      graph-long =
        "log --graph --abbrev-commit --decorate=short --all --format=format:'%C(bold cyan)%h%C(reset) - %C(bold green)%aD%C(reset) %C(yellow)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(brightwhite)%s%C(reset) %C(dim white)- %an%C(reset)'";
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
