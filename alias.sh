#!/bin/bash

# additions and aliases for bashrc
# or add the alias file to the bashrc like this:
# [ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# don't store duplicates/empty commands in history
HISTCONTROL=ignoredups:ignorespace:erasedups

# append to history, don't overwrite (might change history later size too)
shopt -s histappend

function ex() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xf "$1"      ;;
            *.tar.zst)   tar unzstd "$1"  ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *.rar)       unrar e "$1"     ;;
            *.lzma)      unlzma "$1"      ;;
            *.deb)       ar x "$1"        ;;
            *)     echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# general/ misc---------------------------------------------------------------------------------------------------------
alias sudo="sudo "  # so sudo can be used w aliases
alias py="python3"

# system info-----------------------------------------------------------------------------------------------------------
alias ipaddr="ifconfig | grep broadcast | awk '{print $2}'"  # no internet connection
alias myip="curl ipinfo.io/ip"  # internet connection, good for VPNs
alias mem="ps auxf | sort -nr -k 4 | head -10"  # top processes eating memory
alias cpu="ps auxf | sort -nr -k 3 | head -10"  # top processes eating cpu
alias sys="./sysmonitor.sh"

# files & navigation----------------------------------------------------------------------------------------------------
alias ..="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias l.='exa -a | egrep "^\."'  # returns only hidden files

# grep------------------------------------------------------------------------------------------------------------------
alias grep="grep --color=auto"
alias egrep="grep --color=auto"
alias fgrep="grep --color=auto"

# flags-----------------------------------------------------------------------------------------------------------------
alias cp="cp -i"  # asks for confirmation before overwriting if there is an existing file
alias df="df -h"  # human readable
alias mv="mv -i"
alias rm="rm -v"

# youtube-dl------------------------------------------------------------------------------------------------------------
alias yt-mp3="cd ~/Desktop/Music; youtube-dl --extract-audio --audio-format mp3"
alias yt-mp4='cd ~/Desktop/Videos; youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4"'
alias yt-pl='cd ~/Desktop/Videos; youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4" -cw -o "%(playlist)s-%(playlist_uploader)s.%(ext)s" -v'
# format, continue, no overwrites, output template, verbose
# --geo-bypass and --geo-bypass-country CODE could be useful
