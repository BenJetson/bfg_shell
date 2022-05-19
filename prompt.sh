#!/bin/bash

# Source Git Prompt defiinitions
bfg_source "vendor/git-prompt"

# Configure Git Prompt.
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_STATESEPARATOR=" "

## Color Variables ##
# These are calculated once at source time to accelerate prompt handlers.

FG_COLOR_BLACK=$(bfg_escape $'\033[30m')
FG_COLOR_RED=$(bfg_escape $'\033[31m')
FG_COLOR_GREEN=$(bfg_escape $'\033[32m')
FG_COLOR_YELLOW=$(bfg_escape $'\033[33m')
FG_COLOR_BLUE=$(bfg_escape $'\033[34m')
# FG_COLOR_MAGENTA=$(bfg_escape $'\033[35m')
FG_COLOR_CYAN=$(bfg_escape $'\033[36m')
FG_COLOR_WHITE=$(bfg_escape $'\033[37m')
FG_COLOR_BRIGHT_BLACK=$(bfg_escape $'\033[90m')
# FG_COLOR_BRIGHT_RED=$(bfg_escape $'\033[91m')
# FG_COLOR_BRIGHT_GREEN=$(bfg_escape $'\033[92m')
# FG_COLOR_BRIGHT_YELLOW=$(bfg_escape $'\033[93m')
# FG_COLOR_BRIGHT_BLUE=$(bfg_escape $'\033[94m')
# FG_COLOR_BRIGHT_MAGENTA=$(bfg_escape $'\033[95m')
# FG_COLOR_BRIGHT_CYAN=$(bfg_escape $'\033[96m')
# FG_COLOR_BRIGHT_WHITE=$(bfg_escape $'\033[97m')
FG_COLOR_ORANGE=$(bfg_escape $'\033[38;5;202m')

# BG_COLOR_BLACK=$(bfg_escape $'\033[40m')
BG_COLOR_RED=$(bfg_escape $'\033[41m')
BG_COLOR_GREEN=$(bfg_escape $'\033[42m')
BG_COLOR_YELLOW=$(bfg_escape $'\033[43m')
BG_COLOR_BLUE=$(bfg_escape $'\033[44m')
# BG_COLOR_MAGENTA=$(bfg_escape $'\033[45m')
BG_COLOR_CYAN=$(bfg_escape $'\033[46m')
BG_COLOR_WHITE=$(bfg_escape $'\033[47m')
BG_COLOR_BRIGHT_BLACK=$(bfg_escape $'\033[100m')
# BG_COLOR_BRIGHT_RED=$(bfg_escape $'\033[101m')
# BG_COLOR_BRIGHT_GREEN=$(bfg_escape $'\033[102m')
# BG_COLOR_BRIGHT_YELLOW=$(bfg_escape $'\033[103m')
# BG_COLOR_BRIGHT_BLUE=$(bfg_escape $'\033[104m')
# BG_COLOR_BRIGHT_MAGENTA=$(bfg_escape $'\033[105m')
# BG_COLOR_BRIGHT_CYAN=$(bfg_escape $'\033[106m')
# BG_COLOR_BRIGHT_WHITE=$(bfg_escape $'\033[107m')
BG_COLOR_ORANGE=$(bfg_escape $'\033[48;5;202m')


# FG_COLOR_RESET=$(bfg_escape $'\033[39m')
BG_COLOR_RESET=$(bfg_escape $'\033[49m')
ALL_COLOR_RESET=$(bfg_escape $'\033[0m')

BOLD_ON=$(bfg_escape $'\033[1m')
BOLD_OFF=$(bfg_escape $'\033[22m')

COLOR_ENDLINE=$(bfg_escape $'\033[K')

# load minpath
bfg_source "minpath"


## Icon Variables ##
# These are calculated once at source time to accelerate prompt handlers.

# If the shell natively supports unicode, use builtins for speed.
if [ $'\ue0b0' = "$(python3 -c "print('\ue0b0')")" ]; then
    bfg_get_icon() {
        # need to pass directly for unicode escape to process.
        # shellcheck disable=SC2059
        printf "$1"
    }
else
    bfg_get_icon() {
        python3 -c "print('$1')"
    }
fi

ICON_CHEVRON_RIGHT="$(bfg_get_icon "\ue0b0")"
ICON_APPLE="$(bfg_get_icon "\uf179")"
ICON_UBUNTU="$(bfg_get_icon "\uf31b")"
ICON_CONSOLE="$(bfg_get_icon "\ufcb5")"
ICON_SHIELD="$(bfg_get_icon "\uf49c")"
ICON_LOCK="$(bfg_get_icon "\uf023")"
ICON_HOME="$(bfg_get_icon "\uf015")"
ICON_FOLDER="$(bfg_get_icon "\uf07c")"
ICON_BRANCH="$(bfg_get_icon "\uf126")"
ICON_NETWORK="$(bfg_get_icon "\uf817")"

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

## Left Prompt Segments ##

bfg_prompt_segment_head() {
    if [ "$EUID" -ne 0 ]; then # if effective user ID is NOT root
        PROMPT+="$HEAD_FG_COLOR$HEAD_BG_COLOR"
        PROMPT+=" $HEAD_ICON "
        PROMPT+="$HEAD_END_COLOR"
    else
        PROMPT+="$FG_COLOR_WHITE$BG_COLOR_RED"
        PROMPT+=" $ICON_SHIELD root "
        PROMPT+="$FG_COLOR_RED"
    fi
}

bfg_prompt_segment_ssh() {
    # If in a SSH session, show SSH segment.
    if [ -n "$SSH_CLIENT" ]; then
        PROMPT+="$BG_COLOR_CYAN"
        PROMPT+="$ICON_CHEVRON_RIGHT"
        PROMPT+="$FG_COLOR_BLACK "
        PROMPT+="$ICON_NETWORK "
        PROMPT+=$'\h '
        PROMPT+="$FG_COLOR_CYAN"
    fi
}

bfg_prompt_segment_directory() {
    PROMPT+="$BG_COLOR_BLUE"
    PROMPT+="$ICON_CHEVRON_RIGHT"
    PROMPT+="$FG_COLOR_WHITE "

    if [ ! -w "$PWD" ]; then
        PROMPT+="$ICON_LOCK"
    elif [ "$PWD" = "$HOME" ]; then
        PROMPT+="$ICON_HOME"
    else
        PROMPT+="$ICON_FOLDER"
    fi

    PROMPT+="$BOLD_ON "
    if [ "${BFG_SHELL_PROMPT_MINPATH:-0}" -eq 1 ]; then
        bfg_minpath
    else
        PROMPT+=$'\w'
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

        PROMPT+="$git_color_bg"
        PROMPT+="$ICON_CHEVRON_RIGHT"
        PROMPT+="$FG_COLOR_BLACK"
        PROMPT+=" $ICON_BRANCH "
        PROMPT+="$git_status "
        PROMPT+="$git_color_fg"
    fi
}

## Left Prompt Handler ##

bfg_set_prompt() {
    # Clear existing prompt.
    PROMPT=""

    # Add segments.
    bfg_prompt_segment_head
    bfg_prompt_segment_ssh
    bfg_prompt_segment_directory
    bfg_prompt_segment_git

    # Reset colors after prompt, add final chevron.
    PROMPT+="$BG_COLOR_RESET"
    PROMPT+="$ICON_CHEVRON_RIGHT"
    PROMPT+="$ALL_COLOR_RESET$COLOR_ENDLINE"
    PROMPT+=" "
}
