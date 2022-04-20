#!/bin/bash

# Don't know why Mac does not include these editor bindings by default.
export EDITOR="vim"


# If this shell supports line editing, bind settings. (If interactive shell)
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]
then
    # Enable ctrl-x ctrl-e to edit current command.
    autoload -U edit-command-line
    zle -N edit-command-line
    bindkey "^X^E" edit-command-line

    # Fix some common keybinds.
    # To see keys, run cat, press enter, then hit key combo to see output.
    bindkey "^[[H"   beginning-of-line
    bindkey "^[[F"   end-of-line
    bindkey "^[[3~"  delete-char
    bindkey "^[^[[C" forward-word
    bindkey "^[^[[D" backward-word


    # History Search
    # autoload -U history-search-beginning
    # zle -N history-beginning-search-backward history-search-beginning
    # zle -N history-beginning-search-backward history-search-beginning
    bindkey "^[[A" history-beginning-search-backward
    bindkey "^[[B" history-beginning-search-forward

    # Load autocomplete.
    # https://thevaluable.dev/zsh-completion-guide-examples/
    autoload -U compinit; compinit

    # Enable completion extensions.
    zstyle ':completion:*' completer _extensions _complete _approximate

    # Cache autocomplete for performance.
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

    # Use tab menu for autocomplete.
    zstyle ':completion:*' menu select
    bindkey -M menuselect '^[[Z' reverse-menu-complete

    # Make autocomplete case-insensetive.
    zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
fi



# Go env vars
export GOPATH="$HOME/go"

# Add Go binaries to path
export PATH="$PATH:$GOPATH/bin"

# Add Python3 packages to PATH
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.8/bin"


