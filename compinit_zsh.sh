#!/bin/bash

# If this shell supports line editing, bind settings. (If interactive shell)
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]
then
    # Add BFG Shell completions.
    FPATH="$BFG_SHELL_HOME/completions/zsh:$FPATH"
    FPATH="$BFG_SHELL_HOME/local/completions/zsh:$FPATH"

    # compinit will do some checks to make sure permissions are correct.
    # Default behavior is to prompt when it finds files with wrong permissions.
    # Passing -i will make it never use insecure files.
    # Passing -u will make it use insecure files without warning.
    compinit -i
fi
