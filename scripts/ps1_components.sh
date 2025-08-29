#!/bin/bash

shopt -s checkwinsize

# Git prompt components
function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}

# export PS1="\[\033[01;32m\]\u\[\033[01;37m\]@\h \[\033[01;33m\]\T \w\[\033[38;5;40m\]\[\e[0m\] \$ "
function grb_git_prompt() {
    # local g="$(__gitdir)"
    if [ -e ".git" ]; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
        if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
            local COLOR=${RED}
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
            local COLOR=${YELLOW}
        else
            local COLOR=${GREEN}
        fi
        local SINCE_LAST_COMMIT="${COLOR}$(minutes_since_last_commit)m${NORMAL}"
        # local SINCE_LAST_COMMIT="$(minutes_since_last_commit)m"
        # The __git_ps1 function inserts the current git branch where %s is
        local GIT_PROMPT=`__git_ps1 "(%s|${SINCE_LAST_COMMIT})"`
        echo "${GIT_PROMPT}"
    fi
}

function get_columns {
  echo -n $(($COLUMNS-9))
}

DIGITS="\[\e[38;5;160m\]"
BORDER="\[\033[1;37m\]"
# CLOCK="\[\033[s\033[1;\$(echo -n \$(get_columns))\]$BORDER[$DIGITS\$(date +%H:%M:%S)$BORDER]\[\033[u\]"
CLOCK="\033\ $(date +%H:%M:%S)"

# PS1_USER_HOST="\[\e[38;5;15m\]\u\[\e[38;5;160m\]@\[\e[38;5;249m\]\h"
# PS1_WORK_DIR="\[\e[38;5;160m\][\[\e[00;34m\]\W\[\e[38;5;160m\]]"
# PS1_GIT_STAT="\[\e[0m\]\$(grb_git_prompt)"
# PS1_RET_STAT="\[\e[00;33m\]{\$?}"
# PS1_PROMPT_RST="\[\e[0m\]\$ "

get_time(){ echo -en "\033\e[38;5;118m$(date +%H:%M:%S) \e[0m"; };
time_on=false
show_time() {
    [[ $time_on == true ]] && export PS1=$PREV_PS1 && time_on=false && return
    time_on=true
    PREV_PS1=$PS1
    export PS1=\$\(get_time\)$PS1
}

ncolors=$(infocmp -1 | expand | sed -n -e "s/^ *colors#\([0-9][0-9]*\),.*/\1/p")
[[ $ncolors == '' ]] && ncolors='256'
hostcolor=$(echo $(hostname | sum | awk -v ncolors=$ncolors 'ncolors>1 {print 1 + ($1 % (ncolors - 1))}')m)
[[ $hostcolor == "m" ]] && hostcolor='249m'

PS1_USER_HOST="\[\e[38;5;15m\]\u\[\e[38;5;160m\]@\[\e[38;5;$hostcolor\]\h"
PS1_WORK_DIR="\[\e[38;5;160m\][\[\e[00;34m\]\W\[\e[38;5;160m\]]"
PS1_PROMPT_RST="\[\e[0m\]"
PS1_GIT_STAT="\[\e[0m\]\$(grb_git_prompt)\[\e[0m\]"
PS1_RET_STAT="\[\e[00;33m\]{\$?}"

PS1_END="\[\e[0m\]\$ "

if [[ `whoami` == "root" ]]; then
    PS1_USER_HOST="\[\e[38;5;196m\]\u\[\e[38;5;15m\]@\[\e[38;5;15m\]\h"
    PS1_PROMPT_RST="\[\e[38;5;9m\]# "
fi

function get_xilinx_env() {
    if ! [ -z $XILINX_VIVADO ]; then
        echo "(xlnx)"
    fi
}

PS1_XILINX="\[\e[38;5;150m\]\$(get_xilinx_env)\[\e[0m\]"

function get_gitf_env() {
    if ! [ -z $GITF_VERSION ]; then
        echo "(gitf-$remote_name)"
    fi
}

PS1_GITF="\[\e[38;5;150m\]\$(get_gitf_env)\[\e[0m\]"

function get_wind_env() {
    if ! [ -z $WIND_PLATFORM ]; then
        echo "(wenv)"
    fi
}

PS1_WENV="\[\e[38;5;150m\]\$(get_wind_env)\[\e[0m\]"

# first grab the dynamic bits into vars so it's clearer:
GIT_PROMPT="\[\$(grb_git_prompt)\]"
# if get_xilinx_env is plain text, leave it un-bracketed; otherwise bracket it too
XILINX_ENV="$(get_xilinx_env)"
GITF_ENV="$(get_gitf_env)"
WIND_ENV="$(get_wind_env)"

USR_PROMPT=""\
"\[\e[38;5;15m\]\u"\
"\[\e[38;5;160m\]@"\
"\[\e[38;5;32m\]\h"\
"\[\e[38;5;160m\]["\
"\[\e[00;34m\]\W"\
"\[\e[38;5;160m\]]"\
"\[\e[0m\]"\
"\$ "
# "${GIT_PROMPT}"\
# "\[\e[0m\]"\
# "\[\e[38;5;150m\]${XILINX_ENV}\[\e[0m\]"\
# "\[\e[38;5;150m\]${GITF_ENV}\[\e[0m\]"\
# "\[\e[38;5;150m\]${WIND_ENV}\[\e[0m\]"\


# case $(uname) in
#   Linux)
#     USR_PROMPT="$PS1_USER_HOST$PS1_WORK_DIR$PS1_GIT_STAT$PS1_XILINX$PS1_GITF$PS1_WENV$PS1_END"
#     export PLATFORM=linux
#     ;;
#   *)
#     USR_PROMPT="$PS1_USER_HOST$PS1_WORK_DIR$PS1_GITF$PS1_END"
#     ;;
# esac

export PS1="$USR_PROMPT"
export PS2='> '
export PS4='+ '