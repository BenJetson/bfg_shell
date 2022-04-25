#!/bin/bash

if [ -z "$BFG_SHELL_HOME" ]; then
    echo
    echo "ERROR!"
    echo
    echo "This program does not know how to uninstall your BFG Shell instance"
    echo "because \$BFG_SHELL_HOME is not set."
    echo
    exit 1
fi

BFG_BLOCK_BEGIN="## BEGIN:BFG_SHELL ##"
BFG_BLOCK_END="## END:BFG_SHELL ##"

bfg_block_present_in() {
    if [ -f "$1" ] && \
        grep "$BFG_BLOCK_BEGIN" "$1" > /dev/null && \
        grep "$BFG_BLOCK_END" "$1" > /dev/null
    then
        printf 1
    else
        printf 0
    fi
}

bfg_remove_block_from() {
    sed "/$BFG_BLOCK_BEGIN/,/$BFG_BLOCK_END/d" "$1" \
        | tee "$1"
}

bfg_block_removal_warn() {
    echo " - Anything between \"$BFG_BLOCK_BEGIN\" and \"$BFG_BLOCK_END\""
    echo "   will be deleted from $1"
}

ZSHRC_FILE="$HOME/.zshrc"
BASHRC_FILE="$HOME/.bashrc"

INSTALLED_TO_ZSHRC=$(bfg_block_present_in "$ZSHRC_FILE")
INSTALLED_TO_BASHRC=$(bfg_block_present_in "$BASHRC_FILE")

echo
echo "Welcome to the BFG Shell uninstaller."
echo
echo "This script is provided to you under the terms of the license agreement"
echo "that should have been distributed with this program. See LICENSE."
echo
echo "The uninstaller will perform the following actions, which are both"
echo "DESTRUCTIVE and likely to be IRREVERSIBLE:"
echo
echo " - The $BFG_SHELL_HOME directory, and all of its contents,"
echo "   will be deleted from disk"
if [ "$INSTALLED_TO_ZSHRC" -eq 1 ]; then
    bfg_block_removal_warn "$ZSHRC_FILE"
fi
if [ "$INSTALLED_TO_BASHRC" -eq 1 ]; then
    bfg_block_removal_warn "$BASHRC_FILE"
fi
echo
echo "These actions will undo the changes of the BFG Shell installer, but you"
echo "will have to RESTART YOUR SHELL to unload BFG Shell completely."
echo

while true; do
    printf "Would you like to proceed? [y/n]: "
    read -r REPLY
    case $REPLY in
        [yY]) echo ; break ;;
        [nN]) echo ; echo "Abort!"; echo; exit 1 ;;
        *) printf " \033[31m %s \n\033[0m" "invalid input"
    esac
done

bfg_remove_block_from "$HOME/.zshrc"
bfg_remove_block_from "$HOME/.bashrc"
rm -rf "$BFG_SHELL_HOME"

echo
echo "BFG Shell has been uninstalled."
echo "Please RESTART YOUR SHELL to unload BFG Shell completely."
echo
echo "Press any key to acknowledge."
read -r -n 1
