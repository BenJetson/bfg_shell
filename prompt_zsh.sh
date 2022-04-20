#!/bin/bash

# Source Git Prompt defiinitions
source "$BFG_SHELL_HOME/vendor/git-prompt.sh"
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_STATESEPARATOR=" "

bfg_set_prompt() {
    PROMPT_SEPARATOR=$'\ue0b0'
    PROMPT_APPLE=$'\uf179'

    PROMPT=""

    # Start Segment
    if [ "$EUID" -ne 0 ]; then
        PROMPT+=$'%F{black}%K{white} \uf179 %F{white}'
    else
        PROMPT+=$'%F{white}%K{red} \uf49c root %F{red}'
    fi

    # Path Segment
    PROMPT+=$'%K{blue}\ue0b0'
    # PROMPT+=$' %d '

    PROMPT+=$'%F{white} '
    if [ ! -w "$PWD" ]; then
        PROMPT+=$'\uf023' # lock icon
    elif [ "$PWD" = "$HOME" ]; then
        PROMPT+=$'\uf015' # home icon
    else
        PROMPT+=$'\uf07c' # folder icon
    fi

    PROMPT+=$' %B%~%b '

    # PROMPT+=$' %4(c.~/--/.)'
    # PROMPT+=$'%3~ '

    # check conditional logic, notably:
    #True if the current path, with prefix replacement, has at least n elements relative to the root directory, hence / is counted as 0 elements.
    #https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html

    # PROMPT+=$' %3~ '
    # PROMPT+=$' %25<..<%~%<<%  '

    PROMPT+=$'%F{blue}'

    # Git segment
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

    # Reset colors after prompt, add final chevron.
    PROMPT+=$'%k\ue0b0'
    PROMPT+=$'%k%f'
    PROMPT+=$' '
}


bfg_command_timer() {
    bfg_command_start="$SECONDS"
}

bfg_set_rprompt() {
    EXIT_CODE=$?
    bfg_command_end="$SECONDS"
    if [ -n "$bfg_command_start" ]; then
        elapsed=$((bfg_command_end-bfg_command_start))
    else
        elapsed=0
    fi
    unset bfg_command_start

    if [ $EXIT_CODE -eq 0 ]; then
        RPROMPT=""
        RPROMPT+=$'%k%F{green}\ue0b2'
        RPROMPT+=$'%K{green}%F{white}%B'
        # RPROMPT+=$' \u2714 ' # check symbol
        RPROMPT+=$' \uf00c ' # check symbol
        RPROMPT+=$'%K{green}%b'
    else
        RPROMPT=""
        RPROMPT+=$'%k%F{red}\ue0b2'
        RPROMPT+=$'%K{red}%F{yellow}%B'
        RPROMPT+=" $EXIT_CODE "
        # RPROMPT+=$'\u2717 ' # x symbol
        RPROMPT+=$'\uf467 ' # x symbol
        RPROMPT+=$'%K{red}%b'
    fi

    if [ "$elapsed" -gt 2 ]; then
        RPROMPT+=$'%F{yellow}\ue0b2'
        RPROMPT+=$'%K{yellow}%F{black}'
        RPROMPT+=" $elapsed""s "
        RPROMPT+=$'\uf252 ' # hourglass symbol
        RPROMPT+=$'%K{yellow}'
    fi

    RPROMPT+=$'%F{white}\ue0b2'
    RPROMPT+=$'%K{white}%F{black}'
    RPROMPT+=$' %* \uf017 '

    # RPROMPT+=$'%K{black}%F{white}'
    RPROMPT+=$'%k%f'
}

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
