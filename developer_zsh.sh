#!/bin/bash

# If the Developer directory exists and compdef is available, enable completion.
if [ -d "$DEVELOPER_DIR" ] && command -v compdef >/dev/null 2>&1; then
    # Shared autocomplete handler for Developer directory helpers.
    _developer_dir_completion() {
        if [[ $PREFIX == */* ]]; then
            # If a slash is present, suggest deeper completions.
            _files -W "$DEVELOPER_DIR" -/
        else
            # Otherwise, only offer immediate subdirectories of ~/Developer.
            compadd -Q -S '' -- "$DEVELOPER_DIR"/*(/N:t)
        fi
    }

    # Bind completion to functions.
    compdef _developer_dir_completion dcd
    if command -v code >/dev/null 2>&1; then
        compdef _developer_dir_completion dcode
    fi
fi
