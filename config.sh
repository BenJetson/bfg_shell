#!/bin/bash

# Set default editor. Eww emacs.
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

    # Make history search move to end of line.
    autoload -U history-search-end
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end history-search-end

    # History Search Keybinds
    # Note the -end, which moves cursor to end of line.
    bindkey "^[[A" history-beginning-search-backward-end
    bindkey "^[[B" history-beginning-search-forward-end

    # Load autocomplete.
    # https://thevaluable.dev/zsh-completion-guide-examples/
    autoload -U compinit; compinit

    # Load complist module.
    # https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module
    zmodload -i zsh/complist

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
