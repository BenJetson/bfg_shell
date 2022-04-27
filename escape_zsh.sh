#!/bin/bash

bfg_escape() {
    # This escape sequence tells zsh that the characters inside are considered
    # zero-width modifiers for the purposes of calculating prompt length.
    #
    # Without using these to escape ANSI escape sequences, additional spaces may
    # be displayed after the prompt and cause weird spacing issues when typing.
    echo -n $'%{'"$1"$'%}'
}
