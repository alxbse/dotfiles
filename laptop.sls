{% from "map.jinja" import dotfiles with context %}

include:
  - user
  - vim
  - xmonad

sudoers:
  file.uncomment:
    - name: /etc/sudoers
    - regex: '%wheel ALL=\(ALL\) ALL'

core:
  pkg:
    - installed
    - pkgs:
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

# cmd.run hack needed to support arch-chroot install environment
lightdm_enable:
  cmd.run:
    - name: systemctl enable lightdm
    - unless: ls /etc/systemd/system/display-manager.service
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
    - name: /home/{{ dotfiles.user }}/.{{ dir }}
    - makedirs: True
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
{% endfor %}

config-i3:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.config/i3/config
    - source: salt://i3/config
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

config-i3status:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.config/i3status/config
    - source: salt://i3/i3status.conf
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

config-terminator:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.config/terminator/config
    - source: salt://terminator/config

/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=colemak
    - makedirs: True

/etc/lightdm/lightdm.conf:
  file.replace:
    - pattern: '#greeter-hide-users=false'
    - repl: 'greeter-hide-users=true'
