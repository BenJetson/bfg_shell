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

bfg_init() {
    bfg_check_environment

    source "$BFG_SHELL_HOME/alias.sh"
    source "$BFG_SHELL_HOME/config.sh"
    source "$BFG_SHELL_HOME/prompt_zsh.sh"
    source "$BFG_SHELL_HOME/update.sh"

    if [ -f "$BFG_SHELL_HOME/local/alias.sh" ]; then
        source "$BFG_SHELL_HOME/local/alias.sh"
    fi

    if [ -f "$BFG_SHELL_HOME/local/config.sh" ]; then
        source "$BFG_SHELL_HOME/local/config.sh"
    fi
}

bfg_reload() {
    bfg_check_environment

    source "$BFG_SHELL_HOME/init.sh"
    bfg_init

    echo "BFG Shell has been re-initialized."
}
