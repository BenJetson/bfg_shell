#!/bin/bash

bfg_update() {
    bfg_check_environment

    (
        set -e
        cd "$BFG_SHELL_HOME"
        if [ -n "$(git status --porcelain)" ]; then
            echo
            echo "ERROR!"
            echo
            echo "The state of the repository in \$BFG_SHELL_HOME is dirty."
            echo "Please clean the working tree before updating."
            echo
            exit 1
        fi

        git pull
    ) || return $?

    source "$BFG_SHELL_HOME/init.sh"
    bfg_init

    (
        source "$BFG_SHELL_HOME/splash.sh"
        bfg_splash
    )

    echo "Your BFG Shell instance has been updated."
    echo "For release notes, see the GitHub page."
}
