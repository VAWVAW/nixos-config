{
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [┌──\($username$os$hostname\)-(\($git_branch$git_commit$git_status\)-)(\[$git_state\]-)\[$directory\]](green) $all
        [└─](green)$character'';
      right_format = "$status( $cmd_duration)( $jobs)";

      continuation_prompt = "  > ";

      add_newline = false;

      # disabled modules
      line_break.disabled = true;
      nix_shell.disabled = true;
      package.disabled = true;
      rust.disabled = true;
      python.disabled = true;
      scala.disabled = true;
      c.disabled = true;

      #modules
      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold blue";
      };

      os = {
        disabled = false;
        style = "cyan";
        symbols.NixOS = " ";
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
        style = "bold blue";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bold cyan";
      };

      git_commit = {
        format = "[$hash$tag]($style)";
        style = "bold yellow";
        tag_disabled = false;
      };

      git_status = {
        format = "( [$ahead_behind](bold bright-purple)[$stashed$conflicted]($style))";
        ahead = "󰁞$count";
        behind = "󰁆$count";
        diverged = "󰁞$ahead_count󰁆$behind_count";
      };

      git_state = {
        format = "[$state( $progress_current/$progress_total)]($style)";
        style = "bold yellow";
      };

      directory = {
        truncation_length = 0;
        format = "[$read_only]($read_only_style)[$path]($style)";
        style = "bold bright-white";
        read_only = " ";
        repo_root_format =
          "[$read_only]($read_only_style)[$repo_root]($repo_root_style)[$path]($style)";
        repo_root_style = "bold purple";
      };

      character = {
        success_symbol = "[\\$](bold blue)";
        error_symbol = "[\\$](bold red)";
        vimcmd_symbol = "[\\$](bold yellow)";
      };

      status = { disabled = false; };

      cmd_duration = {
        format = "[󰥔 ]($style)[$duration](white)";
        show_notifications = true;
      };

      jobs = {
        format = "[$symbol]($style)( [$number](white))";
        symbol = "󰒓";
        style = "bold 202";
      };
    };
  };
}
