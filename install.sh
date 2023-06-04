#!/bin/bash

DIR=$(
    cd "$(dirname "$0")"
    pwd -P
)

#sh $DIR/install_gitignore.sh

if test -f "$HOME/.zshrc"; then
    echo 'installing for zsh'
    echo "source $DIR/dotfile.sh" >>$HOME/.zshrc
fi

if test -f "$HOME/.bashrc"; then
    echo 'installing for bash'
    echo "source $DIR/dotfile.sh" >>$HOME/.bashrc
fi
