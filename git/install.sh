#!/bin/bash -e

echo "Configuring git ..."

# import install function
source common_funcs.sh

# install git related tools
install_apps "git meld kdiff3"

cd git

echo -n "Please, enter your email: "
read git_mail

cp ./gitconfig ~/.gitconfig
sed -i -e "s/\[mail\]/${git_mail}/g" ~/.gitconfig

# setup diff tool
sudo cp ./diff.py /opt/diff.py

