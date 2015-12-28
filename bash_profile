#############################################
# .bash_profile                             #
# http://github.com/guilhermepaula/dotfiles #
#############################################

# Chamar ~/.bashrc sempre ao logar no console
if [ -f ~/.bashrc ]; then 
    source ~/.bashrc 
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/guilherme/.sdkman"
[[ -s "/Users/guilherme/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/guilherme/.sdkman/bin/sdkman-init.sh"
