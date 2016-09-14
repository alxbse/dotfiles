{% from "map.jinja" import dotfiles with context %}

{{ dotfiles.user }}:
  user.present:
    - shell: /bin/bash
    - home: /home/{{ dotfiles.user }}
    - password: {{ dotfiles.pass }}
    - enforce_password: False
    - groups:
      - wheel
      - audio
      - video
