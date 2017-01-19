xorg_pkgs:
  pkg.installed:
    - pkgs:
      - xorg-server
      - xf86-video-intel
      - xorg-xrandr
      - xorg-xprop
      - xf86-input-libinput

xorg_keyboard:
  file.managed:
    - name: /etc/X11/xorg.conf.d/00-keyboard.conf
    - source: salt://xorg/keyboard.conf

xorg_touchpad:
  file.managed:
    - name: /etc/X11/xorg.conf.d/30-touchpad.conf
    - source: salt://xorg/touchpad.conf
