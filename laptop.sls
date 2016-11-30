{% from "map.jinja" import dotfiles with context %}

include:
  - xorg
  - user
  - vim
  - terminator
  - xmonad
  - firefox

sudo:
  pkg.installed

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
      - bind-tools

lightdm:
  pkg:
    - installed
    - pkgs:
      - lightdm
      - lightdm-gtk-greeter

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

network:
  pkg:
    - installed
    - pkgs:
      - libqmi
      - wpa_supplicant
      - nmap

misc:
  pkg:
    - installed
    - pkgs:
      - unzip
      - pulseaudio
      - openvpn
      - feh
      - cifs-utils
      - mupdf
      - dosfstools
      - markdown
      - scrot
      - tree
      - jq
      - imagemagick

# we COULD just install base-devel for most of these, but salt flags package groups as failed
code:
  pkg:
    - installed
    - pkgs:
      - python-virtualenv
      - ghc
      - make
      - pkg-config
      - flex
      - bison
      - cabal-install
      - stack

{% if 'vmx' in grains['cpu_flags'] and grains['virtual'] == 'physical'%}
virtualization:
  pkg:
    - installed
    - pkgs:
      - qemu
      - ovmf
      - qemu-arch-extra
{% endif %}

/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=colemak
    - makedirs: True

/etc/lightdm/lightdm.conf:
  file.replace:
    - pattern: '#greeter-hide-users=false'
    - repl: 'greeter-hide-users=true'

aur_deps:
  pkg.installed:
    - pkgs:
      - fakeroot

dhcpcd_noarp:
  file.append:
    - name: /etc/dhcpcd.conf
    - text: noarp
