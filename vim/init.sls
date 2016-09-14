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
  file.managed:
    - name: /home/{{ dotfiles.user }}/.vim/autoload/pathogen.vim
    - source: https://raw.githubusercontent.com/tpope/vim-pathogen/v2.4/autoload/pathogen.vim
    - source_hash: sha256=8b78e5a7f15359023fcd3b858b06be31931ec3864c194c56d03c6cd7d8a5933c
    - user: {{ dotfiles.user }}
    - group: {{ dotfiles.user }}

vim-airline:
  git.latest:
    - name: https://github.com/vim-airline/vim-airline.git
    - target: /home/{{ dotfiles.user }}/.vim/bundle/vim-airline

seoul256.vim:
  git.latest:
    - name: https://github.com/junegunn/seoul256.vim.git
    - target: /home/{{ dotfiles.user }}/.vim/bundle/seoul256.vim
