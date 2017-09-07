#!/bin/bash -e

echo "Configuring vim ..."

# import install function
source common_funcs.sh

# install vim related tools
install_apps "vim vim-gtk"

cd vim

# install Vundle plugin
cp -r ./.vim ./.vimrc ~/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
