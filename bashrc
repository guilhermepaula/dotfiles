#############################################
# .bashrc                                   #
# http://github.com/guilhermepaula/dotfiles #
#############################################

###
# General
###

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_05.jdk/Contents/Home
# keep ${PATH} always in the end of line.
export PATH=/usr/local/bin:${PATH}

alias ll='ls -lG'
alias la='ls -A'
alias l='ls -CF'

###
# Themes
###

# CLI Colors
export CLICOLOR=1
# Set "ls" colors
export LSCOLORS=Gxfxcxdxbxegedabagacad

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/guilherme/.sdkman"
[[ -s "/Users/guilherme/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/guilherme/.sdkman/bin/sdkman-init.sh"
