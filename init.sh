#!/bin/bash

bfg_check_environment() {
    if [ -z "$BFG_SHELL_HOME" ]; then
        echo
        echo "ERROR!"
        echo
        echo "Could not initialize BFG Shell because the \$BFG_SHELL_HOME"
        echo "environment variable is not set."
        echo
        exit 1
    fi
}

bfg_run() {
    local target=""
    target="$BFG_SHELL_HOME"/scripts/"$1".sh

    if [ -n "$ZSH_VERSION" ]; then
        zsh "$target" "${@:2}"
    else
        bash "$target" "${@:2}"
    fi
}

bfg_source() {
    source "$BFG_SHELL_HOME/$1.sh"
}

bfg_smart_source() {
    local target=""
    local detected_shell=""

    target="$BFG_SHELL_HOME/$1"

    detected_shell="bash"
    if [ -n "$ZSH_VERSION" ]; then
        detected_shell="zsh"
    fi

    if [ -f "$target.sh" ]; then
        source "$target.sh"
    fi

    if [ -f "$target""_""$detected_shell.sh" ]; then
        source "$target""_""$detected_shell.sh"
    fi
}

bfg_check_interactive_shell() {
    # Checks to see if the current shell's option flags (held in $-) contain the
    # interactive flag (i).
    [[ $- == *i* ]]
}

bfg_check_line_editing_support() {
    # First, for zsh shells, we will verify whether the Zsh Line Editor (ZLE)
    # is active.
    if [ -n "$ZSH_VERSION" ] && [[ -o zle ]]; then
        return 0
    fi
    # Otherwise, check to see if the current shell supports line editing
    # features by looking to see if the vi or emacs shell options are set.
    [[ -o emacs ]] || [[ -o vi ]]
}

bfg_init() {
    bfg_check_environment

    bfg_smart_source "config"
    bfg_smart_source "alias"
    bfg_smart_source "func"
    bfg_smart_source "developer"
    bfg_smart_source "escape"

    bfg_source "update"

    # If is interactive shell, load additional components.
    if bfg_check_interactive_shell; then
        bfg_smart_source "prompt"

        # If this shell supports line editing, bind settings and completion.
        if bfg_check_line_editing_support; then
            bfg_smart_source "bindopt"
            bfg_smart_source "compinit"
        fi
    fi

    # Handle local overrides last.
    bfg_smart_source "local/config"
    bfg_smart_source "local/alias"
    if bfg_check_interactive_shell; then
        bfg_smart_source "local/iconfig"
    fi
}

bfg_reload() {
    bfg_check_environment

    bfg_source "init"
    bfg_init

    echo "BFG Shell has been re-initialized."
}
