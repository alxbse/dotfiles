{% from "map.jinja" import dotfiles with context %}

include:
  - user
  - vim
  - terminator
  - xmonad

sudo:
  pkg.installed

sudo-lectured:
  file.managed:
    - name: /var/db/sudo/lectured/{{ dotfiles.user }}
    - makedirs: True
    - group: {{ dotfiles.user }}

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
      - python-virtualenv
      - ghc

{% if 'vmx' in grains['cpu_flags'] %}
virtualization:
  pkg:
    - installed
    - pkgs:
      - qemu
{% endif %}

/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=colemak
    - makedirs: True

/etc/lightdm/lightdm.conf:
  file.replace:
    - pattern: '#greeter-hide-users=false'
    - repl: 'greeter-hide-users=true'
