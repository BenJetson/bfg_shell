#!/bin/bash

# Basic Editor Commands
# Not sure why Apple doesn't include these editor commands.
alias edit="\$EDITOR"
alias sudoedit="sudo -e"

# Prompt before removing or overwriting files with common commands.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ls Aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# Git Aliases
alias gs='git status'
alias gc='git commit'
alias gcl='git clone'
alias gck='git checkout'
alias gf='git fetch'
alias gp='git pull'
alias gps='git push'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gl='git log'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gbl='git blame'
alias gmg='git merge'
alias gmgne='git merge --no-edit'
alias grm='git rm'
alias grmf='git rm -f'
alias gr='git reset'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'

# iCloud Helper
alias cdicloud='cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs'

# XCode update helper. Runs in subshell, since function block is () not {}.
if [ "$(uname)" = "Darwin" ]; then
    xcfix () (
        set -x
        xcode-select --install

        set -e
        xcode-select -p


        sudo xcodebuild -license accept
        sudo xcodebuild -runFirstLaunch

        sudo -k

        xcodebuild -runFirstLaunch
    )
fi
