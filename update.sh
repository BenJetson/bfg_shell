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

        echo
        echo "Checking for updates..."

        git fetch

        LOCAL_COMMIT_COUNT=$(git rev-list --count HEAD)
        CURRENT_COMMIT_HASH=$(git rev-parse --short HEAD)

        NEW_COMMIT_HASH=$(git rev-parse --short origin)
        REMOTE_COMMIT_COUNT=$(git rev-list --count origin)

        echo
        echo "Update check complete."
        echo
        echo "You are on #$LOCAL_COMMIT_COUNT (hash $CURRENT_COMMIT_HASH)."
        echo "Remote is at #$REMOTE_COMMIT_COUNT (hash $NEW_COMMIT_HASH)."
        echo

        if [ ! "$REMOTE_COMMIT_COUNT" -gt "$LOCAL_COMMIT_COUNT" ]; then
            echo "No update is available."
            echo
            return 1
        fi

        echo "Press return to acknowledge or ^C to abort."
        read -r

        echo "Fast forwarding changes..."
        echo

        git pull --ff-only
    ) || return $?

    bfg_source "init"
    bfg_init

    (
        bfg_source "splash"
        bfg_splash
    )

    echo "Your BFG Shell instance has been updated."
    echo "For release notes, see the GitHub page."
}
