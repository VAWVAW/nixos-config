{ inputs, config, pkgs, lib, hostname, ... }: {
  config = lib.mkIf config.programs.firefox.enable {
    home = {
      persistence."/persist/home/vaw".directories = [{
        directory = ".mozilla/firefox/default";
        method = "bindfs"; # allow home-manager to manage profiles
      }];
      sessionVariables.BROWSER = "firefox";
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

    programs.firejail.wrappedBinaries = {
      "firefox" = {
        executable = "${pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        extraArgs = [
          # U2F USB stick
          "--ignore=private-dev"
          # enable drm
          "--ignore=noexec \\\${HOME}"
          # enable keepassxc browser plugin
          "--noblacklist=\\\${RUNUSER}/app"
          "--whitelist=\\\${RUNUSER}/app"
        ];
      };
      "firefox-unsafe" = {
        executable = "${pkgs.firefox}/bin/firefox --new-instance";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        extraArgs = [
          # U2F USB stick
          "--ignore=private-dev"
          # enable drm
          "--ignore=noexec \\\${HOME}"
          # disable access to ~
          "--private"
        ];
      };
    };

    # backup bookmarks (based on impermanence binds)
    systemd.user.services."bindMount-bookmarks" = let
      name = "bookmarks";
      mountPoint = "/persist/home/vaw/.mozilla/firefox/default/bookmarkbackups";
      targetDir = "/persist/home/vaw/Documents/misc/bookmarks/${hostname}";
      unmountScript = mountPoint: tries: sleep: ''
        triesLeft=${toString tries}
        if ${pkgs.util-linux}/bin/mount | grep -F ${mountPoint}' ' >/dev/null; then
            while (( triesLeft > 0 )); do
                if fusermount -u ${mountPoint}; then
                    break
                else
                    (( triesLeft-- ))
                    if (( triesLeft == 0 )); then
                        echo "Couldn't perform regular unmount of ${mountPoint}. Attempting lazy unmount."
                        fusermount -uz ${mountPoint}
                    else
                        sleep ${toString sleep}
                    fi
                fi
            done
        fi
      '';
      startScript = pkgs.writeShellScript name ''
        set -eu
        if ! mount | grep -F ${mountPoint}' ' && ! mount | grep -F ${mountPoint}/; then
            mkdir -p ${mountPoint}
            exec ${pkgs.bindfs}/bin/mount.fuse.bindfs ${targetDir} ${mountPoint}
        else
            echo "There is already an active mount at or below ${mountPoint}!" >&2
            exit 1
        fi
      '';
      stopScript = pkgs.writeShellScript "unmount-${name}" ''
        set -eu
        ${unmountScript mountPoint 6 5}
      '';
    in {
      Unit = {
        Description = "Bind mount ${targetDir} at ${mountPoint}";

        # Don't restart the unit, it could corrupt data and
        # crash programs currently reading from the mount.
        X-RestartIfChanged = false;

        # Don't add an implicit After=basic.target.
        DefaultDependencies = false;

        Before = [
          "bluetooth.target"
          "basic.target"
          "default.target"
          "paths.target"
          "sockets.target"
          "timers.target"
        ];
      };

      Install.WantedBy = [ "paths.target" ];

      Service = {
        Type = "forking";
        ExecStart = "${startScript}";
        ExecStop = "${stopScript}";
        Environment = "PATH=${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.util-linux
              pkgs.gnugrep
              pkgs.bindfs
            ]
          }:/run/wrappers/bin";
      };
    };

    programs.firefox = {
      profiles."default" = {
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          darkreader
          privacy-badger
          noscript
          vimium
          decentraleyes
          canvasblocker
          startpage-private-search
          user-agent-string-switcher
          ublock-origin
          libredirect
          keepassxc-browser
        ];
        settings = {
          "browser.startup.homepage" =
            "https://www.startpage.com/do/mypage.pl?prfe=5477eda89dbc3d3131b5a2f8aefa6bc806ef7ca1857dc6f5a4c6396f04789fa0f9389b088ec341ce380a470ac2cd451d72a522357c57b0994d35b6c538f5a490ddd7c0bb7765e3e34efdad1a";
          "browser.uiCustomization.state" = ''
            {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","canvasblocker_kkapsner_de-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","keepassxc-browser_keepassxc_org-browser-action","ublock0_raymondhill_net-browser-action","_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action","_b11bea1f-a888-4332-8d8a-cec2be7d24b9_-browser-action","addon_darkreader_org-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","reset-pbm-toolbar-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button","canvasblocker_kkapsner_de-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","keepassxc-browser_keepassxc_org-browser-action","_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","_b11bea1f-a888-4332-8d8a-cec2be7d24b9_-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action","addon_darkreader_org-browser-action","ublock0_raymondhill_net-browser-action","_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list","unified-extensions-area"],"currentVersion":20,"newElementCount":4}'';
          "browser.bookmarks.addedImportButton" = false;
          "gfx.webrender.all" = true;
          "app.normandy.first_run" = false;
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = false;
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "app.update.auto" = false;
          "beacon.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.cache.offline.enable" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.disableResetPrompt" = true;
          "browser.fixup.alternate.enabled" = false;
          "browser.newtab.preload" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" =
            false;
          "browser.newtabpage.enabled" = false;
          "browser.newtabpage.enhanced" = false;
          "browser.newtabpage.introShown" = true;
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.enabled" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.selfsupport.url" = "";
          "browser.send_pings" = false;
          "browser.sessionstore.privacy_level" = 2;
          "browser.sessionstore.resume_from_crash" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.urlbar.trimURLs" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "device.sensors.ambientLight.enabled" = false;
          "device.sensors.enabled" = false;
          "device.sensors.motion.enabled" = false;
          "device.sensors.orientation.enabled" = false;
          "device.sensors.proximity.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.event.clipboardevents.enabled" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "dom.webaudio.enabled" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "experiments.supported" = false;
          "extensions.CanvasBlocker@kkapsner.de.whiteList" = "";
          "extensions.getAddons.cache.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.greasemonkey.stats.optedin" = false;
          "extensions.greasemonkey.stats.url" = "";
          "extensions.pocket.enabled" = false;
          "extensions.shield-recipe-client.api_url" = "";
          "extensions.shield-recipe-client.enabled" = false;
          "extensions.webservice.discoverURL" = "";
          "media.autoplay.default" = 0;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.autoplay.enabled" = false;
          "media.eme.enabled" = false;
          "media.gmp-widevinecdm.enabled" = false;
          "media.navigator.enabled" = false;
          "media.peerconnection.enabled" = false;
          "media.video_stats.enabled" = false;
          "network.allow-experiments" = false;
          "network.captive-portal-service.enabled" = false;
          "network.cookie.cookieBehavior" = 1;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.http.referer.spoofSource" = true;
          "network.http.speculative-parallel-limit" = 0;
          "network.predictor.enable-prefetch" = false;
          "network.predictor.enabled" = false;
          "network.prefetch-next" = false;
          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.query_stripping" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          "privacy.usercontext.about_newtab_segregation.enabled" = true;
          "security.ssl.disable_session_identifiers" = true;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" =
            false;
          "signon.autofillForms" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "webgl.disabled" = true;
          "webgl.renderer-string-override" = " ";
          "webgl.vendor-string-override" = " ";
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "browser.warnOnQuitShortcut" = false;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "network.proxy.socks_remote_dns" = true;
          "network.trr.mode" = 2;
          "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
          "browser.search.hiddenOneOffs" = "Google,Amazon.de,Bing";
          "browser.urlbar.shortcuts.history" = false;
          "browser.formfill.enable" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "places.history.enabled" = false;
          "pref.privacy.disable_button.cookie_exceptions" = false;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.history.custom" = true;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.topsites" = false;
          "signon.rememberSignons" = false;
          "browser.toolbars.bookmarks.visibility" = "always";
          "general.autoScroll" = true;
          "browser.display.use_document_fonts" = 0;
        };
      };
    };
  };
}
