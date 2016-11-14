{% from "map.jinja" import dotfiles with context %}

vim:
  pkg.installed

config-vim:
  file.managed:
    - name: /home/{{ dotfiles.user }}/.vimrc
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}
    - source: salt://vim/vimrc

pathogen:
  file.absent:
    - name: /home/{{ dotfiles.user }}/.vim/autoload/pathogen.vim
    #- source: https://raw.githubusercontent.com/tpope/vim-pathogen/v2.4/autoload/pathogen.vim
    #- source_hash: sha256=8b78e5a7f15359023fcd3b858b06be31931ec3864c194c56d03c6cd7d8a5933c
    #- makedirs: True
    #- user: {{ dotfiles.user }}
    #- group: {{ dotfiles.user }}

vim-airline:
  file.absent:
    - name: /home/alex/.vim/bundle/vim-airline
  git.latest:
    - name: https://github.com/vim-airline/vim-airline.git
    - target: /home/{{ dotfiles.user }}/.vim/pack/airline/start/vim-airline

seoul256.vim:
  file.absent:
    - name: /home/alex/.vim/bundle/seoul256.vim
  git.latest:
    - name: https://github.com/junegunn/seoul256.vim.git
    - target: /home/{{ dotfiles.user }}/.vim/pack/seoul256/start/seoul256.vim

saltstack_vim:
  file.absent:
    - name: /home/alex/.vim/pack/plugins
  git.latest:
    - name: https://github.com/saltstack/salt-vim.git
    - target: /home/{{ dotfiles.user }}/.vim/pack/salt/start/salt-vim
