{% from "map.jinja" import dotfiles with context %}

shell:
  pkg.installed:
    - pkgs:
      - bash
      - bash-completion

{{ dotfiles.user }}:
  user.present:
    - shell: /bin/bash
    - home: /home/{{ dotfiles.user }}
    - password: {{ dotfiles.pass }}
    - enforce_password: False
    - groups:
      - wheel
      - audio
      - video

/home/{{ dotfiles.user }}/source:
  file.directory:
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

/home/{{ dotfiles.user }}/.config/user-dirs.dirs:
  file.managed:
    - contents: |
        XDG_DESKTOP_DIR="$HOME/desktop"
        XDG_DOWNLOAD_DIR="$HOME/downloads"
        XDG_MUSIC_DIR="$HOME/music"

ssh_keepalive:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.ssh/config
    - makedirs: True
    - contents: ServerAliveInterval 120

#irssi:
#  pkg.installed
#
#irssi_conf:
#  file.managed:
#    - name: /home/{{ dotfiles.user }}/.irssi/config
#    - source: salt://user/irssi.conf
#    - template: jinja
#    - makedirs: True

sudo-lectured:
  file.managed:
    - name: /var/db/sudo/lectured/{{ dotfiles.user }}
    - makedirs: True
    - replace: False
    - group: {{ dotfiles.user }}
