#!/bin/bash -e

source common_funcs.sh

PACKAGES_DIR="./packages"

##################################################################################
#  Install skype 4.3.0
#
install_skype_4_3 () {
	echo -n "Installing skype 4.3.0"
	sudo dpkg --add-architecture i386
	sudo apt-get update
	sudo dpkg -i ${PACKAGES_DIR}/skype_4.3.0.37.deb || true
        sudo apt install -f -y
	sudo dpkg -i ${PACKAGES_DIR}/skype_4.3.0.37.deb
}

while true; do
        read -p "Do you want to install skype 4.3.0 ? (y/n) " yn
        case $yn in
                [Yy]* ) install_skype_4_3; break;;
                [Nn]* ) break;;
                * ) echo "Please answer y(yes) or n(no).";;
        esac
done

#################################################################################
# Install other applications
#
app_list="make autoconf cmake realpath htop cscope terminator doublecmd-qt okular pdftk yakuake"

while true; do
	read -p "Do you want to install ${app_list} applications? (y/n) " yn
    	case $yn in
        	[Yy]* ) install_apps "${app_list}"; break;;
        	[Nn]* ) break;;
        	* ) echo "Please answer y(yes) or n(no).";;
  	esac
done

###############################################################################
# Print info about tools in archives
#
cd ${PACKAGES_DIR}
echo -e "Apps in tarball available in '${PACKAGES_DIR}' directory:"
for app_tar in *.tar*; do
    echo -e "\t\t$(tput setaf 2)${app_tar}$(tput sgr 0)"
done
cd - > /dev/null

##############################################################################
# Print info about tools which need to download
#
echo -e "Please, install manually next tools:"
echo -e "\t\t$(tput setaf 2)Sublime Text 3$(tput sgr 0) via     https://www.sublimetext.com/3"
echo -e "\t\t$(tput setaf 2)Skype for Linux$(tput sgr 0) via    https://www.skype.com/en/download-skype/skype-for-linux/"
echo -e "\n"
