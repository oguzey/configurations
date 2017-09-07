#!/bin/bash -e

echo "Configuring bash ..."

source common_funcs.sh
install_apps "grc"

cd bash
cat ./bashrc_append >> ~/.bashrc
