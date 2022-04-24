#!/bin/bash

# Source Git Prompt defiinitions
source "$BFG_SHELL_HOME/vendor/git-prompt.sh"
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_STATESEPARATOR=" "

# minpath
source "$BFG_SHELL_HOME/minpath.sh"

# Color variables.
FG_COLOR_BLACK=$'\033[30m'
FG_COLOR_RED=$'\033[31m'
FG_COLOR_GREEN=$'\033[32m'
FG_COLOR_YELLOW=$'\033[33m'
FG_COLOR_BLUE=$'\033[34m'
FG_COLOR_MAGENTA=$'\033[35m'
FG_COLOR_CYAN=$'\033[36m'
FG_COLOR_WHITE=$'\033[37m'
FG_COLOR_BRIGHT_BLACK=$'\033[90m'
FG_COLOR_BRIGHT_RED=$'\033[91m'
FG_COLOR_BRIGHT_GREEN=$'\033[92m'
FG_COLOR_BRIGHT_YELLOW=$'\033[93m'
FG_COLOR_BRIGHT_BLUE=$'\033[94m'
FG_COLOR_BRIGHT_MAGENTA=$'\033[95m'
FG_COLOR_BRIGHT_CYAN=$'\033[96m'
FG_COLOR_BRIGHT_WHITE=$'\033[97m'

BG_COLOR_BLACK=$'\033[40m'
BG_COLOR_RED=$'\033[41m'
BG_COLOR_GREEN=$'\033[42m'
BG_COLOR_YELLOW=$'\033[43m'
BG_COLOR_BLUE=$'\033[44m'
BG_COLOR_MAGENTA=$'\033[45m'
BG_COLOR_CYAN=$'\033[46m'
BG_COLOR_WHITE=$'\033[47m'
BG_COLOR_BRIGHT_BLACK=$'\033[100m'
BG_COLOR_BRIGHT_RED=$'\033[101m'
BG_COLOR_BRIGHT_GREEN=$'\033[102m'
BG_COLOR_BRIGHT_YELLOW=$'\033[103m'
BG_COLOR_BRIGHT_BLUE=$'\033[104m'
BG_COLOR_BRIGHT_MAGENTA=$'\033[105m'
BG_COLOR_BRIGHT_CYAN=$'\033[106m'
BG_COLOR_BRIGHT_WHITE=$'\033[107m'

FG_COLOR_RESET=$'\033[39m'
BG_COLOR_RESET=$'\033[49m'
ALL_COLOR_RESET=$'\033[0m'

BOLD_ON=$'\033[1m'
BOLD_OFF=$'\033[22m'

ICON_CHEVRON_RIGHT="$(printf '\ue0b0')"

## Left Prompt Segments ##

bfg_prompt_segment_head() {
    if [ "$EUID" -ne 0 ]; then # if effective user ID is NOT root
        PROMPT+="$FG_COLOR_BLACK$BG_COLOR_WHITE"
        PROMPT+=$' \uf179 ' # apple icon
        PROMPT+="$FG_COLOR_WHITE"
    else
        PROMPT+="$FG_COLOR_WHITE$BG_COLOR_RED"
        PROMPT+=$' \uf49c root ' # shield icon
        PROMPT+="$FG_COLOR_RED"
    fi
}

bfg_prompt_segment_directory() {
    PROMPT+="$BG_COLOR_BLUE"
    PROMPT+=$'\ue0b0'
    PROMPT+="$FG_COLOR_WHITE "

    if [ ! -w "$PWD" ]; then
        PROMPT+=$'\uf023' # lock icon
    elif [ "$PWD" = "$HOME" ]; then
        PROMPT+=$'\uf015' # home icon
    else
        PROMPT+=$'\uf07c' # folder icon
    fi

    PROMPT+="$BOLD_ON "
    if [ "$BFG_SHELL_PROMPT_MINPATH" -eq 1 ]; then
        bfg_minpath
    else
        PROMPT+=$'%~'
    fi
    PROMPT+="$BOLD_OFF "

    PROMPT+="$FG_COLOR_BLUE"
}

bfg_prompt_segment_git() {
    git_status=$(__git_ps1 "%s")
    if [[ -n "$git_status" ]]; then
        git_color_fg="$FG_COLOR_GREEN"
        git_color_bg="$BG_COLOR_GREEN"
        if [[ "$git_status" =~ [*!%] ]]; then
            git_color_fg="$FG_COLOR_YELLOW"
            git_color_bg="$BG_COLOR_YELLOW"
        fi

        # there's 2 branch icon options \ue0a0 or \uf126
        PROMPT+="$git_color_bg"
        PROMPT+=$'\ue0b0'
        PROMPT+="$FG_COLOR_BLACK"
        PROMPT+=$' \uf126 '"$git_status "
        PROMPT+="$git_color_fg"
    fi
}

## Left Prompt Handler ##

bfg_set_prompt() {
    # Clear existing prompt.
    PROMPT=""

    # Add segments.
    bfg_prompt_segment_head
    bfg_prompt_segment_directory
    bfg_prompt_segment_git

    # Reset colors after prompt, add final chevron.
    PROMPT+="$BG_COLOR_RESET"
    PROMPT+=$'\ue0b0'
    PROMPT+="$ALL_COLOR_RESET"
    PROMPT+=$'\033[K '

    PS1="$PROMPT"
}

## Use BFG Prompt

PROMPT_COMMAND="bfg_set_prompt"
