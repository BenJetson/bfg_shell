#!/bin/bash

# If the Developer directory exists in $HOME, load helpers.
if [ -d "$DEVELOPER_DIR" ]; then
    # Shared autocomplete handler for ~/Developer directory helpers.
    _developer_dir_completion() {
        local DIR
        local PREFIX="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=()

        if [[ "$PREFIX" == */* ]]; then
            # If a slash is present, suggest deeper completions.
            for DIR in "$DEVELOPER_DIR/$PREFIX"*; do
                if [ -d "$DIR" ]; then
                    COMPREPLY+=("${DIR#$DEVELOPER_DIR/}")
                fi
            done
        else
            # Otherwise, only offer immediate subdirectories of ~/Developer that match.
            for DIR in "$DEVELOPER_DIR/$PREFIX"*; do
                if [ -d "$DIR" ]; then
                    COMPREPLY+=("${DIR##*/}")
                fi
            done
        fi
    }

    # Bind completion handler to defined functions.
    complete -o default -o nospace -F _developer_dir_completion dcd
    if command -v code >/dev/null 2>&1; then
        complete -o default -o nospace -F _developer_dir_completion dcode
    fi
fi
