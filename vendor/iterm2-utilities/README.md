# iterm2-utilities

This directory contains a copy of select scripts from the iTerm2 Utilities
package that I find useful.

## Usage in BFG Shell

BFG Shell does not add these utilities to `PATH` by default.

You may use the optional module to conditionally add them to `PATH` when iTerm2
is detected:

```sh
# $BFG_SHELL_HOME/local/config.sh

bfg_smart_source "opt/it2_utilities_loader"
```

## Original Source

These are subject to the original [LICENSE](./LICENSE) they were provided under.

Please visit the source repository to learn more:

<https://github.com/gnachman/iTerm2-shell-integration>
