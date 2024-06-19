#!/bin/bash

shopt -s checkwinsize

function get_petalinux_env() {
    if ! [ -z $PETALINUX_VER ]; then
        echo "(plnx)"
    fi
}

PS1_PETALINUX="\[\e[38;5;150m\]\$(get_petalinux_env)\[\e[0m\]"

# based on liquidprompt PS1 VCS code

LP_COLOR_UP="\[$(tput setaf 2)\]"
LP_COLOR_COMMITS="\[$(tput setaf 3)\]"
LP_COLOR_COMMITS_BEHIND="$( { tput bold || tput md ; } 2>/dev/null )$(tput setaf 1)"
LP_COLOR_CHANGES="\[$(tput setaf 1)\]"
LP_COLOR_DIFF="\[$(tput setaf 5)\]"
LP_MARK_UNTRACKED="*"
LP_MARK_STASH="+"

LP_LIGHTGREEN="\[\033[38;5;084m\]"

NO_COL="\[$( { tput sgr0 || tput me ; } 2>/dev/null )\]"

_lp_escape()
{
    echo -nE "${1//\\/\\\\}"
}

# Get the branch name of the current directory
_lp_git_branch()
{
    \git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    local branch
    # Recent versions of Git support the --short option for symbolic-ref, but
    # not 1.7.9 (Ubuntu 12.04)
    if branch="$(\git symbolic-ref -q HEAD)"; then
        _lp_escape "${branch#refs/heads/}"
    else
        # In detached head state, use commit instead
        # No escape needed
        \git rev-parse --short -q HEAD
    fi
}


# Display additional information if HEAD is in merging, rebasing
# or cherry-picking state
_lp_git_head_status() {
    local gitdir
    gitdir="$(\git rev-parse --git-dir 2>/dev/null)"
    if [[ -f "${gitdir}/MERGE_HEAD" ]]; then
        echo " MERGING"
    elif [[ -d "${gitdir}/rebase-apply" || -d "${gitdir}/rebase-merge" ]]; then
        echo " REBASING"
    elif [[ -f "${gitdir}/CHERRY_PICK_HEAD" ]]; then
        echo " CHERRY-PICKING"
    fi
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
#
# Add the number of pending commits and the impacted lines.
_lp_git_branch_color()
{
    local branch
    branch="$(_lp_git_branch)"
    if [[ -n "$branch" ]]; then

        local end
        end="${LP_COLOR_CHANGES}$(_lp_git_head_status)${NO_COL}"

        if LC_ALL=C \git status --porcelain 2>/dev/null | \grep -q '^??'; then
            end="$LP_COLOR_CHANGES$LP_MARK_UNTRACKED$end"
        fi

        # Show if there is a git stash
        if \git rev-parse --verify -q refs/stash >/dev/null; then
            end="$LP_COLOR_COMMITS$LP_MARK_STASH$end"
        fi

        local remote
        remote="$(\git config --get branch.${branch}.remote 2>/dev/null)"

        local has_commit=""
        local commit_ahead
        local commit_behind
        if [[ -n "$remote" ]]; then
            local remote_branch
            remote_branch="$(\git config --get branch.${branch}.merge)"
            if [[ -n "$remote_branch" ]]; then
                remote_branch=${remote_branch/refs\/heads/refs\/remotes\/$remote}
                commit_ahead="$(\git rev-list --count $remote_branch..HEAD 2>/dev/null)"
                commit_behind="$(\git rev-list --count HEAD..$remote_branch 2>/dev/null)"
                if [[ "$commit_ahead" -ne "0" && "$commit_behind" -ne "0" ]]; then
                    has_commit="${LP_COLOR_COMMITS}+$commit_ahead${NO_COL}/${LP_COLOR_COMMITS_BEHIND}-$commit_behind${NO_COL}"
                elif [[ "$commit_ahead" -ne "0" ]]; then
                    has_commit="${LP_COLOR_COMMITS}$commit_ahead${NO_COL}"
                elif [[ "$commit_behind" -ne "0" ]]; then
                    has_commit="${LP_COLOR_COMMITS_BEHIND}-$commit_behind${NO_COL}"
                fi
            fi
        fi

        local ret
        local shortstat # only to check for uncommitted changes
        shortstat="$(LC_ALL=C \git diff --shortstat HEAD -- 2>/dev/null)"

        if [[ -n "$shortstat" ]]; then
            local u_stat # shorstat of *unstaged* changes
            u_stat="$(LC_ALL=C \git diff --shortstat 2>/dev/null)"
            u_stat=${u_stat/*changed, /} # removing "n file(s) changed"

            local i_lines # inserted lines
            if [[ "$u_stat" = *insertion* ]]; then
                i_lines=${u_stat/ inser*}
            else
                i_lines=0
            fi

            local d_lines # deleted lines
            if [[ "$u_stat" = *deletion* ]]; then
                d_lines=${u_stat/*\(+\), }
                d_lines=${d_lines/ del*/}
            else
                d_lines=0
            fi

            local has_lines
            has_lines="+$i_lines/-$d_lines"

            if [[ -n "$has_commit" ]]; then
                # Changes to commit and commits to push
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL},$has_commit)"
            else
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL})" # changes to commit
            fi
        elif [[ -n "$has_commit" ]]; then
            # some commit(s) to push
            if [[ "$commit_behind" -gt "0" ]]; then
                ret="${LP_COLOR_COMMITS_BEHIND}${branch}${NO_COL}($has_commit)"
            else
                ret="${LP_COLOR_COMMITS}${branch}${NO_COL}($has_commit)"
            fi
        else
            ret="${LP_COLOR_UP}${branch}" # nothing to commit or push
        fi
        echo -nE "${LP_LIGHTGREEN}{${NO_COL}$ret$end$LP_LIGHTGREEN}$NO_COL"
    fi
}

#USR_PROMPT="$PS1_USER_HOST$PS1_WORK_DIR$PS1_GIT_STAT$PS1_XILINX$PS1_PETALINUX$PS1_GITF$PS1_WENV$PS1_END"
#USR_PROMPT="$PS1_USER_HOST$PS1_WORK_DIR\$(_lp_git_branch_color)$PS1_XILINX$PS1_PETALINUX$PS1_GITF$PS1_WENV$PS1_END"
export PLATFORM=linux
export NOGIT=false
function prompt_command {
  # eval git_branch_color in here: it has some length-counting escapes we need to process
  if $NOGIT; then
      export PS1="$PS1_USER_HOST$PS1_WORK_DIR$PS1_XILINX$PS1_PETALINUX$PS1_GITF$PS1_WENV$PS1_END"
  else
      export PS1="$PS1_USER_HOST$PS1_WORK_DIR$(_lp_git_branch_color)$PS1_XILINX$PS1_PETALINUX$PS1_GITF$PS1_WENV$PS1_END"
  fi
}

function tnogit {
    if $NOGIT; then
        export NOGIT=false
    else
        export NOGIT=true
    fi

}


function is_docker() {
    if grep :/docker /proc/self/cgroup > /dev/null; then
        echo "(docker)"
    fi
}

PS1_DOCKER="\[\e[38;5;150m\]\$(is_docker)\[\e[0m\]"

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}prompt_command"
export PS1="$USR_PROMPT"

