#!/bin/bash

# zmv wildcard helper
# usage: zmvw ../images/vnc_*.png ./prefix_vnc_*.png
alias zmvw='noglob zmv -W'

# Autocomplete helper for dcd function, loaded if defined.
if command -v dcd >/dev/null 2>&1; then
    _dcd() {
        if [[ $PREFIX == */* ]]; then
            # If a slash is present, suggest deeper completions.
            _files -W "$HOME/Developer" -/
        else
            # Otherwise, only offer immediate subdirectories of ~/Developer.
            compadd -Q -S '' -- "$HOME"/Developer/*(/N:t)
        fi
    }
fi

# Autocomplete helper for dcode function, loaded if defined.
if command -v dcode >/dev/null 2>&1; then
    _dcode() {
        if [[ $PREFIX == */* ]]; then
            # If a slash is present, suggest deeper completions.
            _files -W "$HOME/Developer" -/
        else
            # Otherwise, only offer immediate subdirectories of ~/Developer.
            compadd -Q -S '' -- "$HOME"/Developer/*(/N:t)
        fi
    }
fi
