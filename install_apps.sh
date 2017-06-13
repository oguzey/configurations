#!/bin/bash -e

APP_LIST="git make autoconf cmake realpath vim vim-gtk meld kdiff3 grc htop \
          cscope terminator doublecmd-qt okular"

sudo apt update

for app in ${APP_LIST}; do
    dpkg -s "$app" >/dev/null 2>&1 && {
        echo "$app is installed.";
    } || {
        echo "$app is installing...";
        sudo apt install $app -y;
    }
done

echo -n "Installing deb packages from packages directory ..."
cd packages
for app_deb in *.deb; do
    echo -n "Installing $(tput setaf 2)${app_deb}$(tput sgr 0)"
    sudo dpkg -i "${app_deb}"
done

echo -n "Apps in tarball available in packages directory:"
for app_tar in *.tar*; do
    echo -n "\t\t$(tput setaf 2)${app_tar}$(tput sgr 0)"
done
cd -

echo -n "Please, install manually next tools:"
echo -n "\t\t$(tput setaf 2)Sublime Text 3$(tput sgr 0) via     https://www.sublimetext.com/3"
echo -n "\t\t$(tput setaf 2)Skype for Linux$(tput sgr 0) via    https://www.skype.com/en/download-skype/skype-for-linux/"
echo -e "\n"
