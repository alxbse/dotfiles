{% from "map.jinja" import dotfiles with context %}

xmonad-pkgs:
  pkg:
    - installed
    - pkgs:
      - xmonad
      - xmonad-contrib
      - xmobar
      - dmenu
      - slock

purge_stuff:
  pkg.purged:
    - pkgs:
      - dex

xmonad-config-dir:
  file.directory:
    - name: /home/{{ dotfiles.user }}/.xmonad
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

xmonad-config:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.xmonad/xmonad.hs
    - source: salt://xmonad/xmonad.hs
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - template: jinja
    - context:
        terminal: {{ dotfiles.terminal }}

xmobar_config:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.xmobarrc
    - source: salt://xmonad/xmobarrc
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - template: jinja
    - context:
        has_battery: {{ 'batteries' in grains and grains['batteries'] is iterable }}
        user: {{ dotfiles.user }}

xmobar_xinitrc:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.xinitrc
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - mode: 755
    - contents: |
        xrdb -I$HOME ~/.Xresources
        exec xmonad

xmonad_xresources_dir:
  file.directory:
    - name: /home/{{ dotfiles.user }}/.Xresources.d
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

xmonad_xresources_include:
  file.append:
    - name: /home/{{ dotfiles.user }}/.Xresources
    - text: '#include "/home/{{ dotfiles.user }}/.Xresources.d/xmonad"'

xmonad_xresources:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.Xresources.d/xmonad
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - source: salt://xmonad/Xresources

xmonad_fontsdir:
  file.directory:
    - name: /home/{{ dotfiles.user}}/.local/share/fonts
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

xmonad_fontawesome:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.local/share/fonts/fontawesome-webfont.ttf
    - source: https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/fonts/fontawesome-webfont.ttf
    - source_hash: sha256=aa58f33f239a0fb02f5c7a6c45c043d7a9ac9a093335806694ecd6d4edc0d6a8
    - runas: {{ dotfiles.user }}

xmonad_fontcache:
  cmd.run:
    - name: fc-cache
    - onlyif: test -v DISPLAY
    - onchanges:
      - file: xmonad_fontawesome

xmonad_cmus_status:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.xmonad/cmus_status.sh
    - source: salt://xmonad/cmus_status.sh
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - mode: 755
