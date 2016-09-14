{% from "map.jinja" import dotfiles with context %}

xmonad-pkgs:
  pkg:
    - installed
    - pkgs:
      - xmonad
      - xmonad-contrib
      - xmobar

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

xmobar-config:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.xmobarrc
    - source: salt://xmonad/xmobarrc
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
