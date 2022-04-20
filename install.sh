#!/bin/bash

ZSH_BFG_DIRECTORY=~/.zsh_bfg
if [ -f "$ZSH_BFG_DIRECTORY" ] || [ -d "$ZSH_BFG_DIRECTORY" ]; then
    echo "Already exists!"

fi

git clone git@github.com:BenJetson/zsh_bfg.git "$ZSH_BFG_DIRECTORY"

cat << EOF >> "$ZSH_BFG_DIRECTORY"

# ZSH BFG initialization.
source $ZSH_BFG_DIRECTORY/init.sh

EOF

source $ZSH_BFG_DIRECTORY/init.sh
echo
echo "Installation complete. BFG has also been initialized in this shell."
echo "Restarting your shell is recommended."
echo
