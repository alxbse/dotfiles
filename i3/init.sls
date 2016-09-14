i3:
  pkg:
    - installed
    - pkgs:
      - i3-wm
      - i3lock
      - i3status
      - dmenu

config-i3:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.config/i3/config
    - source: salt://i3/config
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

config-i3status:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.config/i3status/config
    - source: salt://i3/i3status.conf
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
