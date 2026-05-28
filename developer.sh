#!/bin/bash

DEVELOPER_DIR="$HOME/Developer"

if [ -d "$DEVELOPER_DIR" ]; then
    # Change directory helper for ~/Developer.
    dcd() {
        # No arguments should result in just entering the developer dir itself.
        local target="$DEVELOPER_DIR/$1"
        if [ "$#" -gt 1 ]; then
            echo "<!> ERROR: Too many arguments." >&2
            return 1
        elif [ ! -d "$target" ]; then
            echo "<!> ERROR: $target does not exist." >&2
            return 1
        fi
        cd "$target" || return 1
    }

    # VSCode launcher helper for ~/Developer, loaded if code command exists.
    if command -v code >/dev/null 2>&1; then
        dcode() {
            local target="$DEVELOPER_DIR/$1"
            if [ "$#" -lt 1 ]; then
                echo "<!> ERROR: Must specify developer directory to open." >&2
                return 1
            elif [ "$#" -gt 1 ]; then
                echo "<!> ERROR: Too many arguments." >&2
                return 1
            elif [ ! -d "$target" ]; then
                echo "<!> ERROR: $target does not exist." >&2
                return 1
            fi
            code "$target" || return 1
        }
    fi
fi
