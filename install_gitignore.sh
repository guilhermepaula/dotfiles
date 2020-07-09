#!/bin/bash
############################
# install_gitignore.sh
# this script calls all files needed to install.
############################

DIR=$( cd "$(dirname "$0")" ; pwd -P )
FILES="Java Grails Gradle Node"
GLOBAL_FILES="JetBrains macOS Vim VisualStudioCode"

mkdir -p $DIR/gitignore

for FILE in $FILES; do
    echo "getting $FILE from github"
    curl --silent https://raw.githubusercontent.com/github/gitignore/master/$FILE.gitignore > $DIR/gitignore/$FILE.gitignore
done

for FILE in $GLOBAL_FILES; do
    echo "getting $FILE from github"
    curl --silent https://raw.githubusercontent.com/github/gitignore/master/Global/$FILE.gitignore > $DIR/gitignore/$FILE.gitignore
done

cat $DIR/gitignore/*.gitignore > $DIR/gitignore_global
git config --global core.excludesfile $DIR/gitignore_global
rm -rf $DIR/gitignore
echo 'Done!'
