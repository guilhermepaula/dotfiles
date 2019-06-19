#!/bin/bash
############################
# install.sh
# this script calls all files needed to install.
############################

DIR=$( cd "$(dirname "$0")" ; pwd -P )

sh $DIR/install_gitignore.sh
sh $DIR/makesymlinks.sh
