#!/bin/bash


install_apps () {
	local app_list=$1

	echo -e "Following applications will be installed: \n\t${app_list}"

	sudo apt update

	for app in ${app_list}; do
    		dpkg -s "$app" >/dev/null 2>&1 && {
       			echo "$app is installed.";
    		} || {
        		echo "$app is installing...";
        		sudo apt install $app -y;
    		}
	done
}

