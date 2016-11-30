{% from "map.jinja" import dotfiles with context %}

docker_loop:
  kmod.present:
    - name: loop

docker_pkgs:
  pkg.installed:
    - pkgs:
      - docker

docker_group:
  group.present:
    - name: docker
    - addusers:
      - {{ dotfiles.user }}

docker_service:
  service.running:
    - name: docker
