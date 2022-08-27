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
alias grm='git rm'
alias grmf='git rm -f'
alias gr='git reset'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'

# Git Prompt ignore aliases.
alias git config --local prompt.ignore 1

# iCloud Helper
alias cdicloud='cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs'
