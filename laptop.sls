{% set user='alex' %}

{{ user }}:
  user.present:
    - shell: /bin/bash
    - home: /home/{{ user }}
    - groups:
      - wheel
      - audio
      - video
core:
  pkg:
    - installed
    - pkgs:
      - vim
      - openssh
      - git

x:
  pkg:
    - installed
    - pkgs:
      - xorg-xinit
      - xorg-server
      - xf86-input-synaptics
      - xf86-video-ati
      - xf86-video-intel

i3:
  pkg:
    - installed
    - pkgs:
      - i3-wm
      - i3lock
      - i3status
      - dmenu

fonts:
  pkg:
    - installed
    - pkgs:
      - ttf-liberation

web:
  pkg:
    - installed
    - pkgs:
      - firefox

misc:
  pkg:
    - installed
    - pkgs:
      - unzip
      - rdesktop
      - terminator
      - pulseaudio
      - openvpn

config-i3:
  file.managed:
    - name: /home/{{ user }}/.config/i3/config
    - source: salt://i3/config
    - user: {{ user }}
    - group: {{ user }}
    - require:
      - file: config-dir-config/i3

{% for dir in ['config/i3', 'config/terminator', 'vim/colors'] %}
config-dir-{{ dir }}:
  file.directory:
    - name: /home/{{ user }}/.{{ dir }}
    - makedirs: True
    - user: {{ user }}
    - group: {{ user }}
{% endfor %}

config-vim:
  file.managed:
    - name: /home/{{ user }}/.vimrc
    - source: salt://vim/vimrc

{% for color in ['seoul256'] %}
config-vim-{{ color }}:
  file.managed:
    - name: /home/{{ user }}/.vim/colors/{{ color }}.vim
    - source: salt://vim/colors/{{ color }}.vim
    - require:
      - file: config-dir-vim/colors
{% endfor %}

config-terminator:
  file.managed:
    - name: /home/{{ user}}/.config/terminator/config
    - source: salt://terminator/config

config-xinit:
  file.managed:
    - name: /home/{{ user}}/.xinitrc
    - contents: 'exec i3'
