#!/bin/bash
############################
# makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

DIR=$(
    cd "$(dirname "$0")"
    pwd -P
)
OLD_SUFFIX="_old"
OLD_DIR="$DIR$OLD_SUFFIX"
FILES="bashrc bash_profile vimrc vim zshrc"

echo "Creating $OLD_DIR for backup of any existing dotfiles in ~"
mkdir -p $OLD_DIR
cd $DIR

for FILE in $FILES; do
    mv ~/.$FILE ~/dotfiles_old/
    echo "Creating symlink to $FILE in home directory."
    ln -s $DIR/$FILE ~/.$FILE
done
echo "...done"
