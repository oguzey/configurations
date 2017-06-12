#!/bin/bash -e

# install applications
./install_apps.sh

# setup git
echo -n "Please, enter your email: "
read git_mail

cp ./git/gitconfig ~/.gitconfig
sed -i -e 's/\[mail\]/${git_mail}/g' ~/.gitconfig

cp ./git/diff.py /opt/diff.py

# setup bash
cp ./bash/bashrc ~/.bashrc

# setup vim
# install Vundle plugin
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -r ./vim/* ~/*
