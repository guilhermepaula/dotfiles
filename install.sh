#!/bin/bash
############################
# install.sh
# this script calls all files needed to install.
############################

echo 'calling gitignore.sh'
sh ./install_gitignore.sh

echo 'calling makesymlinks.sh'
sh ./makesymlinks.sh
