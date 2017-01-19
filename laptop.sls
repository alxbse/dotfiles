{% from "map.jinja" import dotfiles with context %}

include:
  - xorg
  - user
  - vim
  - {{ dotfiles.terminal }}
  - {{ dotfiles.wm }}
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

nodm:
  pkg.installed

nodm_conf:
  file.managed:
    - name: /etc/nodm.conf
    - contents: |
        NODM_USER={{ dotfiles.user }}
        NODM_XSESSION=/home/{{ dotfiles.user }}/.xinitrc

# cmd.run hack needed to support arch-chroot install environment
nodm_enable:
  cmd.run:
    - name: systemctl enable nodm
    - unless: ls /etc/systemd/system/multi-user.target.wants/nodm.service

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
      - wpa_supplicant
      - nmap
      - swaks
      - perl-net-ssleay

misc:
  pkg:
    - installed
    - pkgs:
      - unzip
      - pulseaudio
      - feh
      - mupdf
      - markdown
      - scrot
      - tree
      - jq
      - imagemagick
      - dmidecode
      - p7zip
      - dosfstools
      - pngcrush
      - pulseaudio-alsa
      - cmus
      - sshfs

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
      - autoconf
      - automake
      - gradle

{% if 'vmx' in grains['cpu_flags'] and grains['virtual'] == 'physical'%}
virtualization_pkgs:
  pkg:
    - installed
    - pkgs:
      - qemu
      - ovmf
      - qemu-arch-extra

kvm_membership:
  group.present:
    - name: kvm
    - addusers:
      - {{ dotfiles.user }}
{% endif %}

/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=colemak
    - makedirs: True

aur_deps:
  pkg.installed:
    - pkgs:
      - fakeroot

dhcpcd_noarp:
  file.append:
    - name: /etc/dhcpcd.conf
    - text: noarp

laptop_timesyncd:
  file.replace:
    - name: /etc/systemd/timesyncd.conf
    - pattern: '#NTP='
    - repl: NTP=ntp3.sptime.se ntp4.sptime.se

laptop_enablentp:
  cmd.run:
    - name: timedatectl set-ntp true
    - onchanges:
      - file: laptop_timesyncd

#laptop_boot_options:
#  file.line:
#    - name: /boot/loader/entries/arch.conf
#    - location: end
#    - before: 'options cryptdevice=UUID=.*:cryptroot root=/dev/mapper/cryptroot add_efi_mmap'
#    - mode: insert
#    - content: ' intel_idle.max_cstate=1'

laptop_color_pacman:
  file.uncomment:
     - name: /etc/pacman.conf
     - regex: Color
