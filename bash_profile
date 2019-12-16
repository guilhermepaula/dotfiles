#############################################
# .bash_profile                             #
# http://github.com/guilhermepaula/dotfiles #
#############################################

alias reload="exec $SHELL -l"

#IP
alias myip="curl -s ifconfig.me | cut -d ' ' -f 5"
alias localip="hostname -I | cut -d ' ' -f 1"

#Utilities
alias speedtest="curl -sL https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python"

#npm: list globally-installed packages
alias list-npm="npm list -g --depth=0"

#apt: list manually installed packages
alias list-apt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"

# Navigation
alias ll="ls -l"
alias la="ls -lA"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"

# git aliases
alias ga="git add"
alias gai="git add --interactive"
alias gA="git add --all"
alias gbl="git branch --list --verbose"
alias gcp="git clone --progress"
alias gch="git checkout"
alias gcb="git checkout -B"
alias gcm="git checkout master"
alias gp="git pull --verbose"
alias gca="git commit --amend"
alias gc="git commit"
alias gd="git diff"
alias gundocommit="git reset --soft 'HEAD^'"
alias gundopush="git push -f origin 'HEAD^:master'"
alias gl="git log --decorate --oneline --graph"
alias glg="git log --decorate --graph --abbrev-commit --date=relative"
alias gm="git merge --no-ff"
alias gp="git push"
alias gpom="git push origin master"
alias grao="git remote add origin"
alias grau="git remote add upstream"
alias grv="git remote -v"
alias gs="git status --short --branch"
alias gss="git stash save"
alias gsa="git stash apply"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gsc="git stash clear"
alias gsd="git stash drop"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias emptytrash="rm -rfv ~/.local/share/Trash/*"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias free="$(( $(vm_stat | awk '/free/ {gsub(/\./, "", $3); print $3}') * 4096 / 1048576)) MiB free"

    #Open Chrome
    alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
    #Open VScode
    alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

    #Empty the Trash on all mounted volumes and the main HDD.
    alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

    #Show and Hide hidden files in Finder
    alias finder_show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias finder_hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

    #Delete DS_Store files
    alias finder_clean="find . -type f -name '*.DS_Store' -ls -delete"
fi

###
# Functions
###

function clean() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sudo apt autoremove --purge
        sudo apt autoclean
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew cleanup --force -s
        rm -rfv /Library/Caches/Homebrew/*
        brew tap --repair
    fi
}

function update() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sudo apt update
        sudo apt --with-new-pkgs upgrade -y
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

function killport() {
    if [ -z "$1" ]; then
        echo "usage: $0 PORT"
        echo "ex: $0 80"
    else
        pidFound="$(lsof -t -i:$1 -sTCP:LISTEN)"
        if [ $pidFound ]; then
            echo "killing application running in port $1"
            kill -9 $pidFound
        else
            echo "no application running in port $1"
        fi
    fi
}

function checksys() {
    echo "> Internet: $(ping -c 1 google.com &> /dev/null && echo -e "Connected" || echo -e "Disconnected")"
    echo "> IP: $(myip)"
    echo "> Local IP: $(localip)"
    echo "> Uptime: $(uptime | awk '{print $3,$4,$5}' | sed 's/.$//')"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        echo "> OS: $(lsb_release --description | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}') @ $(uname -mr)"
        echo "> RAM Usage: $(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2}')"
        echo "> SWAP Usage: $(free -m | awk 'NR==3{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2}')"
        echo "> CPU Load: $(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "> OS: $(sw_vers -productName) $(sw_vers -productVersion)"
        pfree=$(vm_stat | sed -n 2p | awk '{print $3}' | sed 's/.$//')
        pwired=$(vm_stat | sed -n 7p | awk '{print $4}' | sed 's/.$//')
        pinact=$(vm_stat | sed -n 4p | awk '{print $3}' | sed 's/.$//')
        panon=$(vm_stat | sed -n 15p | awk '{print $3}' | sed 's/.$//')
        pcomp=$(vm_stat | sed -n 17p | awk '{print $5}' | sed 's/.$//')
        ppurge=$(vm_stat | sed -n 8p | awk '{print $3}' | sed 's/.$//')
        pfback=$(vm_stat | sed -n 14p | awk '{print $3}' | sed 's/.$//')

        to_byte=4096
        byte_to_megabyte=1048576

        pfree=$(( pfree * to_byte / byte_to_megabyte ))
        pwired=$(( pwired * to_byte / byte_to_megabyte ))
        pinact=$(( pinact * to_byte / byte_to_megabyte ))
        panon=$(( panon * to_byte / byte_to_megabyte ))
        pcomp=$(( pcomp * to_byte / byte_to_megabyte ))
        ppurge=$(( ppurge * to_byte / byte_to_megabyte ))
        pfback=$(( pfback * to_byte / byte_to_megabyte ))

        free=$(( pfree + pinact ))
        cached=$(( pfback + ppurge ))
        appmem=$(( panon - ppurge ))
        used=$(( appmem + pwired + pcomp ))

        total_mem=$(( $(sysctl -n hw.memsize) / byte_to_megabyte ))
        total_percent=$(( used * 100 / total_mem ))

        printf "> RAM Usage: %.0f/%.0fMB (%.0f%s)\n" $used $total_mem $total_percent "%"
        echo "> SWAP Usage: $(sysctl -n -o vm.swapusage | awk '{ if( $3+0 != 0 )  printf( "%.0f/%.0fMB (%.0f%s)\n", ($6+0), ($3+0), ($6+0)*100/($3+0), "%" ); }')"
        echo "> CPU Load: $(sysctl -n -o vm.loadavg | awk '{printf($2, $3, $4);}')"
    fi
    echo "> Disk Usage:\\n$(df -Hl / | sed -e /Filesystem/d | awk '{print $1 " " $3 "/" $2 " (" $5 ")"}')"
}

function encode64(){
    echo -n "$1" | base64
    echo ""
}

function decode64(){
    echo -n "$1" | base64 --decode
    echo ""
}

export PATH="/usr/local/sbin:$PATH"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh