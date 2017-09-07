#!/bin/bash -e

setup_dirs="bash git vim"

for dir in ${setup_dirs}; do
	while true; do
    		read -p "Do you want to configure ${dir} tool? (y/n) " yn
    		case $yn in
        		[Yy]* ) ./${dir}/install.sh; break;;
        		[Nn]* ) break;;
        		* ) echo "Please answer y(yes) or n(no).";;
    		esac
	done
done

./install_apps.sh
