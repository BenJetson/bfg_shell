#!/bin/bash

# If this shell supports line editing, bind settings. (If interactive shell)
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]
then
    # Enable some of my favorite shell options.
    # See available options with shopt -p.
    set -o noclobber # do not clobber files with redirection without prompt
    shopt -s histappend # append to history file, not overwrite
    shopt -s histverify # verify history commands before running them
    shopt -s cdspell # automatically correct small errors in names with cd
    shopt -s interactive_comments # allow comments in interactive shell


    # Smarter Tab Completion
    bind "set completion-ignore-case on"
    bind "set show-all-if-ambiguous on"

    # Menu Tab Completion
    bind "TAB:menu-complete"
    bind "set show-all-if-ambiguous on"
    bind "set menu-complete-display-prefix on"

    # History Search
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'

    # Fix some common keybinds.
    # To see keys, run cat, press enter, then hit key combo to see output.
    bind '"\e\e[C": forward-word'
    bind '"\e\e[D": backward-word'
fi
