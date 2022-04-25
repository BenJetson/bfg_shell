#!/bin/bash

##  Color variables. ##

FG_COLOR_BLACK=$'\[\033[30m\]'
FG_COLOR_RED=$'\[\033[31m\]'
FG_COLOR_GREEN=$'\[\033[32m\]'
FG_COLOR_YELLOW=$'\[\033[33m\]'
FG_COLOR_BLUE=$'\[\033[34m\]'
# FG_COLOR_MAGENTA=$'\[\033[35m\]'
# FG_COLOR_CYAN=$'\[\033[36m\]'
FG_COLOR_WHITE=$'\[\033[37m\]'
FG_COLOR_BRIGHT_BLACK=$'\[\033[90m\]'
# FG_COLOR_BRIGHT_RED=$'\[\033[91m\]'
# FG_COLOR_BRIGHT_GREEN=$'\[\033[92m\]'
# FG_COLOR_BRIGHT_YELLOW=$'\[\033[93m\]'
# FG_COLOR_BRIGHT_BLUE=$'\[\033[94m\]'
# FG_COLOR_BRIGHT_MAGENTA=$'\[\033[95m\]'
# FG_COLOR_BRIGHT_CYAN=$'\[\033[96m\]'
# FG_COLOR_BRIGHT_WHITE=$'\[\033[97m\]'
FG_COLOR_ORANGE=$'\[\033[38;5;202m\]'

# BG_COLOR_BLACK=$'\[\033[40m\]'
BG_COLOR_RED=$'\[\033[41m\]'
BG_COLOR_GREEN=$'\[\033[42m\]'
BG_COLOR_YELLOW=$'\[\033[43m\]'
BG_COLOR_BLUE=$'\[\033[44m\]'
# BG_COLOR_MAGENTA=$'\[\033[45m\]'
# BG_COLOR_CYAN=$'\[\033[46m\]'
BG_COLOR_WHITE=$'\[\033[47m\]'
BG_COLOR_BRIGHT_BLACK=$'\[\033[100m\]'
# BG_COLOR_BRIGHT_RED=$'\[\033[101m\]'
# BG_COLOR_BRIGHT_GREEN=$'\[\033[102m\]'
# BG_COLOR_BRIGHT_YELLOW=$'\[\033[103m\]'
# BG_COLOR_BRIGHT_BLUE=$'\[\033[104m\]'
# BG_COLOR_BRIGHT_MAGENTA=$'\[\033[105m\]'
# BG_COLOR_BRIGHT_CYAN=$'\[\033[106m\]'
# BG_COLOR_BRIGHT_WHITE=$'\[\033[107m\]'
BG_COLOR_ORANGE=$'\[\033[48;5;202m\]'


# FG_COLOR_RESET=$'\[\033[39m\]'
BG_COLOR_RESET=$'\[\033[49m\]'
ALL_COLOR_RESET=$'\[\033[0m\]'

BOLD_ON=$'\[\033[1m\]'
BOLD_OFF=$'\[\033[22m\]'

COLOR_ENDLINE=$'\[\033[K\]'

## Icon Variables ##

bfg_get_icon() {
    python3 -c "print('\u$1')"
}

ICON_CHEVRON_RIGHT="$(bfg_get_icon e0b0)"
ICON_APPLE="$(bfg_get_icon f179)"
ICON_UBUNTU="$(bfg_get_icon f31b)"
ICON_CONSOLE="$(bfg_get_icon fcb5)"
ICON_SHIELD="$(bfg_get_icon f49c)"
ICON_LOCK="$(bfg_get_icon f023)"
ICON_HOME="$(bfg_get_icon f015)"
ICON_FOLDER="$(bfg_get_icon f07c)"
ICON_BRANCH="$(bfg_get_icon f126)"
ICON_NETWORK="$(bfg_get_icon f817)"

## Head Segment Detection ##

HEAD_FG_COLOR="$FG_COLOR_WHITE"
HEAD_BG_COLOR="$BG_COLOR_BRIGHT_BLACK"
HEAD_END_COLOR="$FG_COLOR_BRIGHT_BLACK"
HEAD_ICON="$ICON_CONSOLE"

case "$(uname)" in
    'Darwin')
        HEAD_FG_COLOR="$FG_COLOR_BLACK"
        HEAD_BG_COLOR="$BG_COLOR_WHITE"
        HEAD_END_COLOR="$FG_COLOR_WHITE"
        HEAD_ICON="$ICON_APPLE"
        ;;
    'Linux')
        HEAD_FG_COLOR="$FG_COLOR_WHITE"
        HEAD_BG_COLOR="$BG_COLOR_ORANGE"
        HEAD_END_COLOR="$FG_COLOR_ORANGE"
        HEAD_ICON="$ICON_UBUNTU"
        ;;
esac

# If in a SSH session, append hostname and network icon.
if [ -n "$SSH_CLIENT" ]; then
    HEAD_ICON+=" $ICON_NETWORK "
    HEAD_ICON+=$'\h'
fi

## Left Prompt Segments ##

bfg_prompt_segment_head() {
    if [ "$EUID" -ne 0 ]; then # if effective user ID is NOT root
        PS1+="$HEAD_FG_COLOR$HEAD_BG_COLOR"
        PS1+=" $HEAD_ICON "
        PS1+="$HEAD_END_COLOR"
    else
        PS1+="$FG_COLOR_WHITE$BG_COLOR_RED"
        PS1+=" $ICON_SHIELD root "
        PS1+="$FG_COLOR_RED"
    fi
}

bfg_prompt_segment_directory() {
    PS1+="$BG_COLOR_BLUE"
    PS1+="$ICON_CHEVRON_RIGHT"
    PS1+="$FG_COLOR_WHITE "

    if [ ! -w "$PWD" ]; then
        PS1+="$ICON_LOCK"
    elif [ "$PWD" = "$HOME" ]; then
        PS1+="$ICON_HOME"
    else
        PS1+="$ICON_FOLDER"
    fi

    PS1+="$BOLD_ON "
    if [ "${BFG_SHELL_PROMPT_MINPATH:-0}" -eq 1 ]; then
        # minpath writes to PROMPT by default
        PROMPT=""
        bfg_minpath
        PS1+="$PROMPT"
    else
        PS1+=$'\w'
    fi
    PS1+="$BOLD_OFF "

    PS1+="$FG_COLOR_BLUE"
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

        PS1+="$git_color_bg"
        PS1+="$ICON_CHEVRON_RIGHT"
        PS1+="$FG_COLOR_BLACK"
        PS1+=" $ICON_BRANCH "
        PS1+="$git_status "
        PS1+="$git_color_fg"
    fi
}

## Left Prompt Handler ##

bfg_set_prompt() {
    # Clear existing prompt.
    PS1=""

    # Add segments.
    bfg_prompt_segment_head
    bfg_prompt_segment_directory
    bfg_prompt_segment_git

    # Reset colors after prompt, add final chevron.
    PS1+="$BG_COLOR_RESET"
    PS1+="$ICON_CHEVRON_RIGHT"
    PS1+="$ALL_COLOR_RESET$COLOR_ENDLINE"
    PS1+=" "
}

## Use BFG Prompt

PROMPT_COMMAND="bfg_set_prompt"
