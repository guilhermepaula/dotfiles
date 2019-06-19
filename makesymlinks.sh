#!/bin/bash
############################
# makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

dir=~/dotfiles
olddir=~/dotfiles_old
files="bashrc bash_profile vimrc vim zshrc"

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
cd $dir

for file in $files; do
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
echo "...done"