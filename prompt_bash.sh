#!/bin/bash

## PS1 Transcoder

bfg_set_ps1() {
    bfg_set_prompt
    PS1="$PROMPT"
}

## Use BFG Prompt

PROMPT_COMMAND="bfg_set_ps1"
