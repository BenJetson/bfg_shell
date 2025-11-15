#!/bin/bash

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
    bindkey "^[^[[C" forward-word
    bindkey "^[^[[D" backward-word

    # Load the zmv multiple file moving utility.
    autoload zmv

    # Use bash word style, which will respect directory delimiters.
    autoload -U select-word-style
    select-word-style bash

    # Just leaving this note here for myself.
    # Deleting words forwards/backwards requires configuring what key sequences
    # iTerm 2 sends when option+delete or option+fn+delete are pressed.
    #
    # Add these bindings to iTerm2 Preferences > Keys > Key Bindings:
    #   - Option +  <- Delete (backspace) maps to Send Hex Codes "0x1b 0x7f".
    #   - Option + Del -> (delete) maps to Send Escape Sequence and enter "d".

    # Make history search move to end of line.
    autoload -U history-search-end
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end history-search-end

    # History Search Keybinds
    # Note the -end, which moves cursor to end of line.
    bindkey "^[[A" history-beginning-search-backward-end
    bindkey "^[[B" history-beginning-search-forward-end

    # Detect when Docker completions have been added to the system and add them
    # to FPATH. If these are missing, you can run:
    #     docker completion zsh > ~/.docker/completions/_docker
    # See also: https://docs.docker.com/engine/cli/completion/
    if [ -d "$HOME/.docker/completions" ]; then
        FPATH="$HOME/.docker/completions:$FPATH"
    fi

    # Load complist module.
    # This should be loaded before compinit so it can populate menu style.
    # https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module
    zmodload -i zsh/complist

    # Load autocomplete.
    # https://thevaluable.dev/zsh-completion-guide-examples/
    autoload -U compinit
    # compinit will do some checks to make sure permissions are correct.
    # Default behavior is to prompt when it finds files with wrong permissions.
    # Passing -i will make it never use insecure files.
    # Passing -u will make it use insecure files without warning.
    compinit -i

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

    # Enable some of my favorite shell options.
    # See also: https://zsh.sourceforge.io/Doc/Release/Options.html
    set -o autocd # cd to directory if command not found is directory name
    set -o autopushd # push to dirs stack when doing cd
    set -o pushdignoredups # ignore duplicates in dirs stack
    set -o pushdminus # swap behavior of minus and plus in dirs
    set -o interactivecomments # allow comments in interactive shell
    set -o histignoredups # ignore immediate duplicate entries in history
    set -o histignorespace # do not history save commands starting with space
    set -o histexpiredupsfirst # expire duplicate entries from history first
    set -o extendedhistory # save timestamps and time elapsed to history
    set -o histverify # verify history commands before running them
    set -o noclobber # do not clobber files with redirection without prompt
    set -o completeinword # do completion in this middle of words
    set -o longlistjobs # print jobs list in long format
    set -o sharehistory # share history between windows
fi
