#!/bin/bash -e

APP_LIST="git make autoconf cmake realpath vim-gtk meld kdiff3"

for app in ${APP_LIST}; do
    dpkg -s "$app" >/dev/null 2>&1 && {
        echo "$app is installed.";
    } || {
        echo "$app is installing...";
        sudo apt-get install $app -y;
    }
