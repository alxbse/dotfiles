{% from "map.jinja" import dotfiles with context %}

urxvt_pkgs:
  pkg.installed:
    - pkgs:
      - rxvt-unicode
      - urxvt-perls

urxvt_xresources_dir:
  file.directory:
    - name: /home/{{ dotfiles.user }}/.Xresources.d
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

urxvt_xresources:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.Xresources.d/urxvt
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - contents:
      - 'urxvt.font: xft:Mono:size=9'
      - 'urxvt.letterSpace: -1'
      - 'urxvt.foreground: white'
      - 'urxvt.background: black'
      - 'urxvt.scrollBar: false'
      - 'urxvt.scrollTtyOutput: false'
      - 'urxvt.secondaryScreen: 1'
      - 'urxvt.secondaryScroll: 0'
      - 'urxvt.color3: #d8af5f'
      - 'urxvt.color4: #85add4'
      - 'urxvt.color12: #add4fb'
      - 'urxvt.scrollTtyKeypress: true'
      - 'urxvt.perl-ext-common: default,matcher,resize-font'
      - 'urxvt.url-launcher: /usr/bin/xdg-open'
      - 'urxvt.matcher.button: 1'
      - 'urxvt.fading: 25'

urxvt_xresources_include:
  file.append:
    - name: /home/{{ dotfiles.user }}/.Xresources
    - text: '#include "/home/{{ dotfiles.user }}/.Xresources.d/urxvt"'

urxvt_xrdb:
  cmd.run:
    - name: 'xrdb -I$HOME /home/{{ dotfiles.user }}/.Xresources'
    - onchanges:
      - file: urxvt_xresources
      - file: urxvt_xresources_include

urxvt_resize_font:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.urxvt/ext/resize-font
    - source: https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font
    - source_hash: aee65c165a6ade6998d32a6cbb84a1ea285aba2c3dc1be1c73c8a54620b4bd64
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
