#!/bin/bash

# zmv wildcard helper
# usage: zmvw ../images/vnc_*.png ./prefix_vnc_*.png
alias zmvw='noglob zmv -W'

# If the Developer directory exists in $HOME, load helpers.
if [ -d "$HOME/Developer" ]; then
    # Shared autocomplete handler for ~/Developer directory helpers.
    _developer_dir_completion() {
        if [[ $PREFIX == */* ]]; then
            # If a slash is present, suggest deeper completions.
            _files -W "$HOME/Developer" -/
        else
            # Otherwise, only offer immediate subdirectories of ~/Developer.
            compadd -Q -S '' -- "$HOME"/Developer/*(/N:t)
        fi
    }
fi
