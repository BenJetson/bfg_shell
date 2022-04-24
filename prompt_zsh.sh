#!/bin/bash

# Source Git Prompt defiinitions
source "$BFG_SHELL_HOME/vendor/git-prompt.sh"
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_STATESEPARATOR=" "

# Disable right prompt spacing.
export ZLE_RPROMPT_INDENT=0

# minpath
source "$BFG_SHELL_HOME/minpath.sh"


## Head Segment Detection ##

HEAD_FG_COLOR=$'white'
HEAD_BG_COLOR=$'8'
HEAD_ICON=$'\ufcb5' # console icon

case "$(uname)" in
    'Darwin')
        HEAD_FG_COLOR=$'black'
        HEAD_BG_COLOR=$'white'
        HEAD_ICON=$'\uf179' # apple icon
        ;;
    'Linux')
        HEAD_FG_COLOR=$'white'
        HEAD_BG_COLOR=$'202' # orange
        HEAD_ICON=$'\uf31b' # ubuntu icon
        ;;
esac

# If in a SSH session, append hostname and network icon.
if [ -n "$SSH_CLIENT" ]; then
    HEAD_ICON+=$' \uf817' # network icon
    HEAD_ICON+=$' %m'
fi

## Left Prompt Segments ##

bfg_prompt_segment_head() {
    if [ "$EUID" -ne 0 ]; then # if effective user ID is NOT root
        PROMPT+=$'%F{'"$HEAD_FG_COLOR"$'}'
        PROMPT+=$'%K{'"$HEAD_BG_COLOR"$'}'
        PROMPT+=" $HEAD_ICON "
        PROMPT+=$'%F{'"$HEAD_BG_COLOR"$'}'
    else
        PROMPT+=$'%F{white}%K{red} \uf49c root %F{red}' # shield icon
    fi
}

bfg_prompt_segment_directory() {
    PROMPT+=$'%K{blue}\ue0b0'

    PROMPT+=$'%F{white} '
    if [ ! -w "$PWD" ]; then
        PROMPT+=$'\uf023' # lock icon
    elif [ "$PWD" = "$HOME" ]; then
        PROMPT+=$'\uf015' # home icon
    else
        PROMPT+=$'\uf07c' # folder icon
    fi

    if [ "$BFG_SHELL_PROMPT_MINPATH" -eq 1 ]; then
        PROMPT+=$' %B'
        bfg_minpath
        PROMPT+=$'%b '
    else
        PROMPT+=$' %B%~%b '
    fi

    PROMPT+=$'%F{blue}'
}

bfg_prompt_segment_git() {
    git_status=$(__git_ps1 "%s")
    if [[ -n "$git_status" ]]; then
        git_color=$'green'
        if [[ "$git_status" =~ [*!%] ]]; then
            git_color=$'yellow'
        fi

        # there's 2 branch icon options \ue0a0 or \uf126
        PROMPT+=$'%K{'"$git_color"$'}'
        PROMPT+=$'\ue0b0'
        PROMPT+=$'%F{black} \uf126 '"$git_status "
        PROMPT+=$'%F{'"$git_color"$'}'
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
    PROMPT+=$'%k\ue0b0'
    PROMPT+=$'%k%f'
    PROMPT+=$' '
}

## Command Timer Helper ##

bfg_command_timer() {
    bfg_command_start="$SECONDS"
}

## Right Prompt Segments ##

bfg_rprompt_segment_exitcode() {
    if [ $exit_code -eq 0 ]; then
        RPROMPT+=$'%k%F{green}\ue0b2'
        RPROMPT+=$'%K{green}%F{white}%B'
        # RPROMPT+=$' \u2714 ' # check symbol
        RPROMPT+=$' \uf00c ' # check symbol
        RPROMPT+=$'%K{green}%b'
    else
        RPROMPT+=$'%k%F{red}\ue0b2'
        RPROMPT+=$'%K{red}%F{yellow}%B'
        RPROMPT+=" $exit_code "
        # RPROMPT+=$'\u2717 ' # x symbol
        RPROMPT+=$'\uf467 ' # x symbol
        RPROMPT+=$'%K{red}%b'
    fi
}

bfg_rprompt_segment_elapsed() {
    if [ -n "$bfg_command_start" ]; then
        elapsed=$((bfg_command_end-bfg_command_start))
    else
        elapsed=0
    fi
    unset bfg_command_start

    if [ "$elapsed" -gt 2 ]; then
        RPROMPT+=$'%F{yellow}\ue0b2'
        RPROMPT+=$'%K{yellow}%F{black}'
        RPROMPT+=" $elapsed""s "
        RPROMPT+=$'\uf252 ' # hourglass symbol
        RPROMPT+=$'%K{yellow}'
    fi
}

bfg_rprompt_segment_clock() {
    RPROMPT+=$'%F{white}\ue0b2'
    RPROMPT+=$'%K{white}%F{black}'
    RPROMPT+=$' %* \uf017 '
}

## Right Prompt Handler ##

bfg_set_rprompt() {
    # Collect right prompt information.
    exit_code=$?
    bfg_command_end="$SECONDS"

    # Clear existing right prompt.
    RPROMPT=""

    # Add right prompt segments.
    bfg_rprompt_segment_exitcode
    bfg_rprompt_segment_elapsed
    bfg_rprompt_segment_clock

    # Reset colors after right prompt.
    RPROMPT+=$'%k%f'
}

## Initialization ##

# On initialization, add BFG functions to precmd, if not already present.
bfg_precmds=( bfg_set_prompt bfg_set_rprompt )
for target in "${bfg_precmds[@]}"; do
    should_add=1
    if [ ${#precmd_functions[@]} -gt 0 ]; then
        for fn in "${precmd_functions[@]}"; do
            if [[ "$fn" = "$target" ]]; then
                should_add=0
                break;
            fi
        done
    fi

    if [ $should_add -eq 1 ]; then
        precmd_functions+=( "$target" )
    fi
done

# On initialization, add BFG functions to preexec, if not already present.
bfg_preexecs=( bfg_command_timer )
for target in "${bfg_preexecs[@]}"; do
    should_add=1
    if [ ${#preexec_functions[@]} -gt 0 ]; then
        for fn in "${preexec_functions[@]}"; do
            if [[ "$fn" = "$target" ]]; then
                should_add=0
                break;
            fi
        done
    fi

    if [ $should_add -eq 1 ]; then
        preexec_functions+=( "$target" )
    fi
done

