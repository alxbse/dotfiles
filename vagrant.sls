{% from "map.jinja" import dotfiles with context %}

vagrant_pkg:
  pkg.installed:
    - name: vagrant

vagrant_virtualbox:
  pkg.installed:
    - pkgs:
      - virtualbox
      - virtualbox-host-dkms
      - virtualbox-guest-iso
      - linux-headers
      - net-tools

vagrant_virtualbox_modules:
  kmod.present:
    - mods:
      - vboxdrv
      - vboxpci
      - vboxnetadp
      - vboxnetflt

vagrant_virtualbox_machinefolder:
  cmd.run:
    - name: VBoxManage setproperty machinefolder /home/{{ dotfiles.user }}/virtualbox
    - runas: {{ dotfiles.user }}
    - unless: grep defaultMachineFolder=\"/home/{{ dotfiles.user }}/virtualbox\" /home/{{ dotfiles.user }}/.config/VirtualBox/VirtualBox.xml

vagrant_virtualbox_no_autoload:
  file.symlink:
    - name: /usr/lib/modules-load.d/virtualbox-host-dkms.conf
    - target: /dev/null
    - backupname: /usr/lib/modules-load.d/virtualbox-host-dkms.conf.pacsave

vagrant_rsync:
  pkg.installed:
    - names:
      - rsync
