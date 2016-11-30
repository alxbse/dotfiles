{% from "map.jinja" import dotfiles with context %}

vagrant:
  pkg.installed

virtualbox:
  pkg.installed:
    - pkgs:
      - virtualbox
      - virtualbox-host-dkms
      - virtualbox-guest-iso
      - linux-headers
      - net-tools

vboxdrv:
  kmod.present

machinefolder:
  cmd.run:
    - name: VBoxManage setproperty machinefolder /home/{{ dotfiles.user }}/virtualbox
    - unless: grep defaultMachineFolder=\"/home/{{ dotfiles.user }}/virtualbox\" /home/{{ dotfiles.user }}/.config/VirtualBox/VirtualBox.xml

no_autostart:
  file.symlink:
    - name: /usr/lib/modules-load.d/virtualbox-host-dkms.conf
    - target: /dev/null
    - backupname: /usr/lib/modules-load.d/virtualbox-host-dkms.conf.pacsave
