#!/bin/bash

# Disable right prompt spacing.
export ZLE_RPROMPT_INDENT=0

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

