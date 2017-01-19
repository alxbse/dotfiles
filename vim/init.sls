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

vim-airline:
  file.absent:
    - name: /home/alex/.vim/bundle/vim-airline
  git.latest:
    - name: https://github.com/vim-airline/vim-airline.git
    - target: /home/{{ dotfiles.user }}/.vim/pack/airline/start/vim-airline
    - user: {{ dotfiles.user }}

seoul256.vim:
  file.absent:
    - name: /home/alex/.vim/bundle/seoul256.vim
  git.latest:
    - name: https://github.com/junegunn/seoul256.vim.git
    - target: /home/{{ dotfiles.user }}/.vim/pack/seoul256/start/seoul256.vim
    - user: {{ dotfiles.user }}

saltstack_vim:
  file.absent:
    - name: /home/alex/.vim/pack/plugins
  git.latest:
    - name: https://github.com/saltstack/salt-vim.git
    - target: /home/{{ dotfiles.user }}/.vim/pack/salt/start/salt-vim
    - user: {{ dotfiles.user }}

vim_indentline:
  git.latest:
    - name: https://github.com/Yggdroot/indentLine
    - target: /home/{{ dotfiles.user }}/.vim/pack/indentLine/start/indentLine
    - user: {{ dotfiles.user }}
