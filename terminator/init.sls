{% from "map.jinja" import dotfiles with context %}

terminator:
  pkg.installed

terminator-config:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.config/terminator/config
    - source: salt://terminator/config
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
