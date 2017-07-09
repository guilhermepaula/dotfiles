#############################################
# .zshrc                                    #
# http://github.com/guilhermepaula/dotfiles #
#############################################

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Keep it in the end
if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
fi