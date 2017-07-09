#############################################
# .bash_profile                             #
# http://github.com/guilhermepaula/dotfiles #
#############################################

#IP
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

#Utilities
alias speedtest="curl -sL https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python"

# Shortcuts
alias ll="ls -lG"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    #TODO
elif [[ "$OSTYPE" == "darwin"* ]]; then
    #Open Chrome
    alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

    #Empty the Trash on all mounted volumes and the main HDD.
    alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

    #Show and Hide hidden files in Finder
    alias finder_show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias finder_hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

    #Delete DS_Store files
    alias finder_clean="find . -type f -name '*.DS_Store' -ls -delete"
fi

###
# Themes
###

# CLI Colors
export CLICOLOR=1
# Set "ls" colors
export LSCOLORS=Gxfxcxdxbxegedabagacad

###
# Functions
###

function clean() {
    echo "Cleaning"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sudo apt-get autoremove
        sudo apt-get autoclean
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew cleanup --force -s
        rm -rfv /Library/Caches/Homebrew/*
        brew tap --repair
    fi
}

function update() {
    echo "Updating"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sudo apt-get update
        sudo apt-get upgrade
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        sudo softwareupdate -i -a
        brew update
        brew upgrade
    fi
}

function checkport() {
    if [ -z "$1" ]; then
        lines=$(lsof -P -s TCP:LISTEN -i TCP | tail -n +2)
        pairs=$(echo -n "$lines" | awk '{split($9,a,":"); print $2":"a[2]}' | uniq)
        format_string="%5s %5s %s\n"

        if [ -n "$pairs" ]; then
            printf "$format_string" "PORT" "PID" "COMMAND"
            for pair in $pairs; do
                port="${pair/#*:}"
                proc="${pair/%:*}"
                cmnd="$(ps -p "$proc" -o command=)"
                printf "$format_string" "$port" "$proc" "${cmnd:0:$COLUMNS-12}"
            done
        fi

    else
        pid=$(lsof -P -s TCP:LISTEN -i TCP:"$1" -t | uniq)
        if [ -n "$pid" ]; then
            ps -p "$pid" -o pid,command
        fi
    fi
}

export PATH="/usr/local/sbin:$PATH"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion