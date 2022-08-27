#!/bin/bash

bfg_git_ignore() {
    bfg_git_ignore_usage () {
        echo "BFG Shell utility that controls display of the git prompt segment"
        echo "at the repository level."
        echo
        echo "Usage:"
        echo "  bfg_git_ignore"
        echo "  bfg_git_ignore -u"
        echo "  bfg_git_ignore -h"
        echo
        echo "Options: "
        echo "  -u   unset the ignore flag for this repository"
        echo "  -h   show this help message"
    }

    local OPTIND
    local ignore=1

    while getopts 'uh' flag; do
        case "${flag}" in
            u) ignore=0 ;;
            h) bfg_git_ignore_usage; return 0 ;;
            *) bfg_git_ignore_usage; return 1 ;;
        esac
    done

    repo_root=$(git rev-parse --show-toplevel)

    if [ $ignore -eq 1 ]; then
        git config --local prompt.ignore 1
        echo "Git segment will now ignore repo: $repo_root"
    else
        git config --local --unset prompt.ignore
        echo "Git segment will now display for repo: $repo_root"
    fi
}
