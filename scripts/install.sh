#!/bin/bash

set -e

if [ -z "$BFG_SHELL_HOME" ]; then
    export BFG_SHELL_HOME="$HOME/.bfg_shell"
fi

SHOULD_CLONE=0
if [ -z "$BFG_SHELL_NO_CLONE" ]; then
    if [ -f "$BFG_SHELL_HOME" ] || [ -d "$BFG_SHELL_HOME" ]; then
        echo
        echo "ERROR!"
        echo
        echo "A directory or file already exists at $BFG_SHELL_HOME."
        echo
        echo "If you want to udpate an existing installation of BFG Shell, "
        echo "simply run bfg_update. If you have already cloned the repo and"
        echo "set \$BFG_SHELL_HOME and just need setup, re-run this script"
        echo "with BFG_SHELL_NO_CLONE=1 set in the environment."
        echo
        exit 1
    fi

    SHOULD_CLONE=1
fi

CLONE_USING_HTTPS=0
if [ -n "$BFG_SHELL_CLONE_HTTPS" ]; then
    CLONE_USING_HTTPS=1
fi

DETECTED_SHELL="bash"
if [ -n "$ZSH_VERSION" ]; then
    DETECTED_SHELL="zsh"
fi
CONFIG_FILE_DISPLAY=".$DETECTED_SHELL""rc"
CONFIG_FILE="$HOME/.$DETECTED_SHELL""rc"

NEEDS_CLEANUP=0
if grep -q "## BEGIN:BFG_SHELL ##" "$CONFIG_FILE" && \
        grep -q "## END:BFG_SHELL ##" "$CONFIG_FILE"; then
    NEEDS_CLEANUP=1
fi

echo
echo "Welcome to the BFG Shell installer."
echo
echo "The installer has detected that your shell is $DETECTED_SHELL."
echo
echo "This software is provided to you under the terms of the license agreement"
echo "that should have been distributed with this program. See LICENSE."
echo
echo "The installer will perform the following actions:"
echo
if [ "$SHOULD_CLONE" -eq 1 ]; then
    echo " - The BFG Shell repository will be cloned to $BFG_SHELL_HOME"
    if [ "$CLONE_USING_HTTPS" -eq 1 ]; then
        echo "   using an HTTPS connection."
    else
        echo "   using an SSH connection."
    fi
else
    echo " - Per your instructions, your existing BFG Shell install located"
    echo "   at $BFG_SHELL_HOME will be used and clone will not occur."
fi
if [ "$NEEDS_CLEANUP" -eq 1 ]; then
    echo " - Anything between \"## BEGIN:BFG_SHELL ##\" and "
    echo "   \"## END:BFG_SHELL ##\" will be deleted from $CONFIG_FILE"
fi
echo " - The BFG Shell initializer will be added to your $CONFIG_FILE"
echo " - BFG Shell scripts will be sourced into this shell session."
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

if [ "$SHOULD_CLONE" -eq 1 ]; then
    if [ "$CLONE_USING_HTTPS" -eq 1 ]; then
        git clone https://github.com/BenJetson/bfg_shell.git "$BFG_SHELL_HOME"
    else
        git clone git@github.com:BenJetson/bfg_shell.git "$BFG_SHELL_HOME"
    fi
fi

if [ "$NEEDS_CLEANUP" -eq 1 ]; then
    sed "/## BEGIN:BFG_SHELL ##/,/## END:BFG_SHELL ##/d" "$CONFIG_FILE" \
        | tee "$CONFIG_FILE"
fi

cat << EOF >> "$CONFIG_FILE"
## BEGIN:BFG_SHELL ##

# It is strongly recommended that you do not edit this section.
# This section is automatically generated by the BFG Shell installation program
# and future versions may overwrite this segment of your $CONFIG_FILE_DISPLAY.

export BFG_SHELL_HOME="$BFG_SHELL_HOME"
source "\$BFG_SHELL_HOME/init.sh"
bfg_init

## END:BFG_SHELL ##
EOF

source "$BFG_SHELL_HOME/init.sh"
bfg_init

(
    bfg_source "splash"
    bfg_splash
)

echo
echo "Installation complete. BFG Shell has been initialized here."
echo "Restarting your shell is recommended."
echo
