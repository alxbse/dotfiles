{% set user='alex' %}

{{ user }}:
  user.present:
    - shell: /bin/bash
    - home: /home/{{ user }}
    - groups:
      - wheel
      - audio
      - video

sudoers:
  file.uncomment:
    - name: /etc/sudoers
    - regex: '%wheel ALL=\(ALL\) ALL'

core:
  pkg:
    - installed
    - pkgs:
      - vim
      - openssh
      - git
      - openntpd
      - bind-tools
      - gptfdisk

xorg:
  pkg:
    - installed
    - pkgs:
      - xorg-server
      - xf86-input-synaptics
      - xf86-video-ati
      - xf86-video-intel
      - lightdm
      - lightdm-gtk-greeter
  file.managed:
    - name: /etc/X11/xorg.conf.d/00-keyboard.conf
    - source: salt://xorg/keyboard.conf

lightdm:
  service.enabled

i3:
  pkg:
    - installed
    - pkgs:
      - i3-wm
      - i3lock
      - i3status
      - dmenu
      - terminator

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
      - nmap
      - swaks

misc:
  pkg:
    - installed
    - pkgs:
      - unzip
      - rdesktop
      - pulseaudio
      - openvpn
      - feh
      - cifs-utils
      - mupdf
      - dosfstools
      - markdown

code:
  pkg:
    - installed
    - pkgs:
      - base-devel
      - python-virtualenv
      - ghc

{% if 'vmx' in grains['cpu_flags'] %}
virtualization:
  pkg:
    - installed
    - pkgs:
      - qemu
{% endif %}

{% for dir in ['config/i3', 'config/terminator', 'vim/autoload', 'vim/bundle', 'config/i3status'] %}
config-dir-{{ dir }}:
  file.directory:
    - name: /home/{{ user }}/.{{ dir }}
    - makedirs: True
    - user: {{ user }}
    - group: {{ user }}
{% endfor %}

config-i3:
  file.managed:
    - name: /home/{{ user }}/.config/i3/config
    - source: salt://i3/config
    - user: {{ user }}
    - group: {{ user }}

config-i3status:
  file.managed:
    - name: /home/{{ user }}/.config/i3status/config
    - source: salt://i3/i3status.conf
    - user: {{ user }}
    - group: {{ user }}

config-vim:
  file.managed:
    - name: /home/{{ user }}/.vimrc
    - user: {{ user }}
    - group: {{ user }}
    - source: salt://vim/vimrc

pathogen:
  file.managed:
    - name: /home/{{ user }}/.vim/autoload/pathogen.vim
    - source: https://raw.githubusercontent.com/tpope/vim-pathogen/v2.4/autoload/pathogen.vim
    - source_hash: sha256=8b78e5a7f15359023fcd3b858b06be31931ec3864c194c56d03c6cd7d8a5933c
    - user: {{ user }}
    - group: {{ user }}

vim-airline:
  git.latest:
    - name: https://github.com/vim-airline/vim-airline.git
    - target: /home/{{ user}}/.vim/bundle/vim-airline

seoul256.vim:
  git.latest:
    - name: https://github.com/junegunn/seoul256.vim.git
    - target: /home/{{ user }}/.vim/bundle/seoul256.vim

config-terminator:
  file.managed:
    - name: /home/{{ user}}/.config/terminator/config
    - source: salt://terminator/config

/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=colemak
    - makedirs: True

/etc/lightdm/lightdm.conf:
  file.replace:
    - pattern: '#greeter-hide-users=false'
    - repl: 'greeter-hide-users=true'
