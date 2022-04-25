# BFG Shell

![install splash screen](https://user-images.githubusercontent.com/10427974/164923770-c18733a7-15d5-462e-9264-16c888e5c19a.png)

## What is this?

This repository contains my personal shell settings, prompt, and other
customizations.

It is intended just to be for my own personal use, but is available to you
under the terms of the [license agreement](./LICENSE) if you would like to use
or copy this project.

## Rationale

The goals of this project are to ...

- pull my favorite features from
  [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) and
  [powerlevel10k](https://github.com/romkatv/powerlevel10k).
- **never** make network requests on startup required to render first prompt
  - (prevents the classic problem of hanging `omz update` when you have no
    network connection)
- have just the features I need, without the bloat
- start up and deliver the prompt quickly
- support all shells that I use frequently
- solve configuration by
  - have some global config synced to all machines through the repo
  - be able to have some config just for that machine

## Supported Shells

Supports `zsh` and `bash`.

## Getting Started

Run the installation script for your shell.

```sh
# For Bash
bash <(curl -s https://raw.githubusercontent.com/BenJetson/bfg_shell/main/install.sh)

# For Zsh
zsh <(curl -s https://raw.githubusercontent.com/BenJetson/bfg_shell/main/install.sh)
```

Then simply follow the prompts and restart your shell when you are done.

## Updating

BFG Shell does not check for updates automatically (right now). To update your
installation, run:

```sh
# For Bash or Zsh
bfg_update
```

Note that this will get the latest version always. This may introduce breaking
changes at any time, without warning. This project is designed for my personal
use, so there isn't really any versioning or release notes going on here.

## Removal

If you decide you do not want to use BFG Shell anymore, an uninstallation script
is provided that should reverse the effects of the installer.

**Read the output of this script very carefully.** It can perform destructive
actions that may be irreversible.

```sh
# For Bash or Zsh
$BFG_SHELL_HOME/uninstall.sh
```
