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

        LOCAL_BRANCH=$(git symbolic-ref --short HEAD)

        LOCAL_COMMIT_COUNT=$(git rev-list --count HEAD)
        CURRENT_COMMIT_HASH=$(git rev-parse --short HEAD)

        NEW_COMMIT_HASH=$(git rev-parse --short origin)
        REMOTE_COMMIT_COUNT=$(git rev-list --count origin)

        echo
        echo "Update check complete."
        echo
        echo "You are on the $LOCAL_BRANCH branch."
        echo
        echo "Local is at #$LOCAL_COMMIT_COUNT (hash $CURRENT_COMMIT_HASH)."
        echo "Remote is at #$REMOTE_COMMIT_COUNT (hash $NEW_COMMIT_HASH)."
        echo
        echo "You can see a diff of the changes and list of commits here:"
        printf "https://github.com/BenJetson/bfg_shell/compare/%s...%s\n" \
            "$CURRENT_COMMIT_HASH" "$NEW_COMMIT_HASH"
        echo

        if [ ! "$REMOTE_COMMIT_COUNT" -gt "$LOCAL_COMMIT_COUNT" ]; then
            echo "No update is available."
            echo
            return 1
        fi

        while true; do
            printf "Would you like to update? [y/n]: "
            read -r REPLY
            case $REPLY in
                [yY]) echo ; break ;;
                [nN]) echo ; echo "Abort!"; echo; exit 1 ;;
                *) printf " \033[31m %s \n\033[0m" "invalid input"
            esac
        done

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

    echo "Your BFG Shell installation has been updated."
    echo "For release notes, see the GitHub page."
}
