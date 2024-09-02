final: _prev: {
  goimapnotify-patched = final.buildGoModule {
    pname = "goimapnotify";
    version = "2.3.15-git";

    src = final.fetchFromGitLab {
      owner = "shackra";
      repo = "goimapnotify";
      rev = "c4944f707de3b103ea2b18eafde3af26ddb3fafe";
      sha256 = "sha256-HcRGNBxO+esbaI3AslDJPnxbvzX48P20d4IBC/PHeuE=";
    };

    vendorHash = "sha256-rWPXQj0XFS/Mv9ylGv09vol0kkRDNaOAEgnJvSWMvoI=";

    patches = [ ./fix-imap-id.patch ];

    postPatch = ''
      for f in command.go command_test.go; do
        substituteInPlace $f --replace '"sh"' '"${final.runtimeShell}"'
      done
    '';

    meta = with final.lib; {
      description =
        "Execute scripts on IMAP mailbox changes (new/deleted/updated messages) using IDLE";
      homepage = "https://gitlab.com/shackra/goimapnotify";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ wohanley rafaelrc ];
      mainProgram = "goimapnotify";
    };
  };
}
