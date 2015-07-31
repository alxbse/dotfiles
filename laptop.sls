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
      - openntpd
      - bind-tools

xorg:
  pkg:
    - installed
    - pkgs:
      - xorg-xinit
      - xorg-server
      - xf86-input-synaptics
      - xf86-video-ati
      - xf86-video-intel
  file.managed:
    - name: /etc/X11/xorg.conf.d/00-keyboard.conf
    - source: salt://xorg/keyboard.conf

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
      - ttf-bitstream-vera
      - ttf-inconsolata
      - ttf-ubuntu-font-family
      - ttf-dejavu
      - ttf-freefont
      - ttf-linux-libertine

web:
  pkg:
    - installed
    - pkgs:
      - firefox
      - gst-libav
      - gst-plugins-good

network:
  pkg:
    - installed
    - pkgs:
      - libqmi
      - wpa_supplicant

misc:
  pkg:
    - installed
    - pkgs:
      - unzip
      - rdesktop
      - terminator
      - pulseaudio
      - openvpn
      - feh
      - keepass
      - cifs-utils
      - inkscape

code:
  pkg:
    - installed
    - pkgs:
      - base-devel
      - python-virtualenv

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
