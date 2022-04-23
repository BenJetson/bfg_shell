# `local` directory

The `local` directory may (optionally) contain customizations that BFG Shell
will load automatically on startup.

## Types

The following types are available:

- `config` - contains shell configuration options or environment variables, etc.
- `aliases` - contains command aliases

Both must end with `.sh` to be loaded.

## Global Files

Without any additional suffix, the local files are considered to be global and
will be loaded in both `bash` or `zsh`.

## Per-Shell Files

If the `_zsh` or `_bash` suffix is added to the filename, then the local file
will only be loaded in the corresponding shell.

For example, `config_zsh.sh` will load configuration only for the `zsh` shell.

If both a global and per-shell local file are available, **both** will be
loaded.
