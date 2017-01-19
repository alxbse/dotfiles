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
    - remove_groups: False
    - groups:
      - wheel
      - audio
      - video
      - kvm

{% for dir in ['source', 'mount', 'temp', 'music'] %}
{{ dir }}_directory:
  file.directory:
    - name: /home/{{ dotfiles.user }}/{{ dir }}
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
{% endfor %}

/home/{{ dotfiles.user }}/.config/user-dirs.dirs:
  file.managed:
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - contents: |
        XDG_DESKTOP_DIR="$HOME/desktop"
        XDG_DOWNLOAD_DIR="$HOME/downloads"
        XDG_MUSIC_DIR="$HOME/music"

ssh_keepalive:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.ssh/config
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
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

sudo_dir:
  file.directory:
    - name: /var/db/sudo
    - mode: 711

sudo_lectured_dir:
  file.directory:
    - name: /var/db/sudo/lectured
    - mode: 700

sudo-lectured:
  file.managed:
    - name: /var/db/sudo/lectured/{{ dotfiles.user }}
    - makedirs: False
    - replace: False
    - group: {{ dotfiles.user }}

shell_prompt:
  file.replace:
    - name: /home/{{ dotfiles.user }}/.bashrc
    - pattern: PS1=.*
    - repl: PS1="\[$(tput setaf 2)\][\W] \[$(tput setaf 3)\]$\[$(tput sgr0)\] "

user_color_grep:
  file.append:
    - name: /home/{{ dotfiles.user }}/.bashrc
    - text: alias grep='grep --color=auto'

user_pulseaudio:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.config/pulse/client.conf
    - contents: |
        autospawn = yes
