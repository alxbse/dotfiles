xorg_pkgs:
  pkg.installed:
    - pkgs:
      - xorg-server
      - xf86-input-synaptics
      - xf86-video-intel
      - xorg-xrandr

/etc/X11/xorg.conf.d/00-keyboard.conf:
  file.managed:
    - source: salt://xorg/keyboard.conf
