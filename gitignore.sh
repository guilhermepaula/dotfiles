#!/bin/bash
############################
# install_gitignore.sh
# this script calls all files needed to install.
############################

########## Variables

dir=~/dotfiles

##########

mkdir -p $dir/gitignore

echo "getting configurations from github..."

echo -ne '#          (10%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Java.gitignore > $dir/gitignore/Java.gitignore
echo -ne '##         (20%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Grails.gitignore > $dir/gitignore/Grails.gitignore
echo -ne '###        (30%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Gradle.gitignore > $dir/gitignore/Gradle.gitignore
echo -ne '####       (40%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore > $dir/gitignore/Node.gitignore
echo -ne '#####      (50%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Yeoman.gitignore > $dir/gitignore/Yeoman.gitignore
echo -ne '######     (60%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Global/Eclipse.gitignore > $dir/gitignore/Eclipse.gitignore
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Global/JetBrains.gitignore > $dir/gitignore/JetBrains.gitignore
echo -ne '#######    (70%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Global/OSX.gitignore > $dir/gitignore/OSX.gitignore
echo -ne '########   (80%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Global/SVN.gitignore > $dir/gitignore/SVN.gitignore
echo -ne '#########  (90%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore > $dir/gitignore/Vim.gitignore
echo -ne '########## (100%)\r'
curl --silent https://raw.githubusercontent.com/github/gitignore/master/Global/SublimeText.gitignore > $dir/gitignore/SublimeText.gitignore
echo -ne '\n'

cat $dir/gitignore/*.gitignore > $dir/gitignore_global

## configures git to use the files

git config --global core.excludesfile $dir/gitignore_global

## clean everything
rm -rf $dir/gitignore
echo 'Done!'
