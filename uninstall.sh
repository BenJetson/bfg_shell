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

echo
echo "Welcome to the BFG Shell uninstaller."
echo
echo "This script is provided to you under the terms of the license agreement"
echo "that should have been distributed with this program. See LICENSE."
echo
echo "The uninstaller will perform the following actions, which are both"
echo "DESTRUCTIVE and likely to be IRREVERSIBLE:"
echo
echo " - Anything between \"## BEGIN:BFG_SHELL ##\" and \"## END:BFG_SHELL ##\""
echo "   will be deleted from $HOME/.zshrc"
echo " - The $BFG_SHELL_HOME directory, and all of its contents, will be"
echo "   deleted forever"
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

sed "/## BEGIN:BFG_SHELL ##/,/## END:BFG_SHELL ##/d" "$HOME/.zshrc" \
    | tee "$HOME/.zshrc"
rm -rf "$BFG_SHELL_HOME"

echo
echo "BFG Shell has been uninstalled."
echo "Please RESTART YOUR SHELL to unload BFG Shell completely."
echo
echo "Press any key to acknowledge."
read -r -n 1
