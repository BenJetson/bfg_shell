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
    "$BFG_SHELL_HOME"/scripts/"$1".sh
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

bfg_init() {
    bfg_check_environment

    bfg_smart_source "alias"
    bfg_smart_source "config"
    bfg_smart_source "prompt"
    bfg_source "update"

    bfg_smart_source "local/alias"
    bfg_smart_source "local/config"
}

bfg_reload() {
    bfg_check_environment

    bfg_source "init"
    bfg_init

    echo "BFG Shell has been re-initialized."
}
