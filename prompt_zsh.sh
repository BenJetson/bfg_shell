#!/bin/bash

# Disable right prompt spacing.
export ZLE_RPROMPT_INDENT=0



## End Color Helper ##
# XXX See notes in prompt.sh about COLOR_ENDLINE.
# In ZSH, this seems to cause issues with the RPROMPT when unset.
# When this is not set, colors in RPROMPT streak the screen on SIGWINCH.
ZSH_COLOR_ENDLINE=$(bfg_escape $'\033[K')
bfg_set_prompt_color_endl() {
    PROMPT+="$ZSH_COLOR_ENDLINE"
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
        RPROMPT+=$'%K{red}%F{yellow}%B '
        # Show the exit code, some are special.
        # See also: https://tldp.org/LDP/abs/html/exitcodes.html
        case "$exit_code" in
            # Invocation errors.
            126) RPROMPT+="NO EXEC";;
            127) RPROMPT+="NO CMD" ;;

            # Special signal exit codes. 128 plus the code.
            #
            # You can run a command to see exit codes on your system.
            #   macOS: kill -l | tr " " "\n" | cat -n
            #   Linux: kill -l
            #
            # Note that signals can differ by system. The ones here are common
            # to both macOS and Linux with the same code number.
            129) RPROMPT+="HUP" ;;
            130) RPROMPT+="INT" ;;
            131) RPROMPT+="QUIT";;
            132) RPROMPT+="ILL" ;;
            134) RPROMPT+="ABRT";;
            136) RPROMPT+="FPE" ;;
            137) RPROMPT+="KILL";;
            139) RPROMPT+="SEGV";;
            141) RPROMPT+="PIPE";;
            142) RPROMPT+="ALRM";;
            143) RPROMPT+="TERM";;
            156) RPROMPT+="WINCH";;

            # Unknown; just show the code.
            *) RPROMPT+="$exit_code" ;;
        esac

        # RPROMPT+=$'\u2717 ' # x symbol
        RPROMPT+=$' \uf467 ' # x symbol
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
bfg_precmds=( bfg_set_prompt bfg_set_prompt_color_endl bfg_set_rprompt )
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

