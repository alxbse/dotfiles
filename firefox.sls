firefox_pkgs:
  pkg.installed
    - pkgs:
      - firefox
      - gst-libav
      - gst-plugins-good

firefox_local_settings:
  file.managed:
    - name: /usr/lib/firefox/defaults/pref/local-settings.js
    - contents: |
        pref("general.config.obscure_value", 0);
        pref("general.config.filename", "mozilla.cfg");

firefox_configuration:
  file.managed:
    - name: /usr/lib/firefox/mozilla.cfg
    - contents: |
        //
        lockPref("signon.rememberSignons", false);
