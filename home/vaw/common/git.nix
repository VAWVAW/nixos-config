{
  programs.git = {
    enable = true;
    userEmail = "valentin@wiedekind1.de";
    userName = "vaw";
    aliases = {
      blm = "blame -w -C -C -C";
      graph = "graph-branch --all";
      graph-branch =
        "log --graph --abbrev-commit --decorate=short --format=format:'%C(bold cyan)%h%C(reset) - %C(yellow)(%ar)%C(reset) %C(brightwhite)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      graph-long =
        "log --graph --abbrev-commit --decorate=short --all --format=format:'%C(bold cyan)%h%C(reset) - %C(bold green)%aD%C(reset) %C(yellow)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(brightwhite)%s%C(reset) %C(dim white)- %an%C(reset)'";
    };
    signing = {
      key = "508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8";
      signByDefault = false;
    };
    extraConfig = {
      init.defaultBranch = "main";
      branch.sort = "-committerdate";

      diff = {
        tool = "nvimdiff";
        mnemonicprefix = true;
        algorithm = "histogram";
        colorMoved = "default";
      };
      merge = {
        conflictstyle = "zdiff3";
        tool = "nvimdiff";
      };
      rebase.autosquash = true;
      rerere.enabled = true;
    };
    ignores = [ "*~" "*.swp" "result" ];

    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers-zero-style = "white";
        line-numbers-minus-style = "red";
        syntax-theme = "Monokai Extended Bright";
        file-style = "brightcyan";
        hunk-header-line-number-style = "white";
        wrap-right-percent = "0.1";
      };
    };
  };
}
