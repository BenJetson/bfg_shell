#!/bin/bash

# minpath
bfg_source "minpath"

# Source Git Prompt defiinitions
bfg_source "vendor/git-prompt"

# Configure Git Prompt.
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_STATESEPARATOR=" "
