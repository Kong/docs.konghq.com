---
title: Configuration
---

decK can be configured using CLI flags, environment variables, and a configuration file on disk.

decK reads these configuration sources in the following priority order:
1. CLI flags override all other values.
2. Environment variables override the configuration file.
3. Configuration file values are treated as defaults.

## CLI flags

To view the available CLI flags for a command, run `deck <command> --help`. 
You can provide these flags when running the command. For example:

```bash
deck gateway sync --konnect-control-plane-name demo --konnect-token $KONNECT_TOKEN kong.yaml
```

## Environment variables

All CLI flags can also be provided as environment variables.

To determine the environment variable name, replace the `.` and `-` characters in the CLI flag with `_` and prefix it with `DECK_`.

To run the same `deck gateway sync` command as above using enviroment variables:

```bash
export DECK_KONNECT_CONTROL_PLANE_NAME=demo
export DECK_KONNECT_TOKEN=$KONNECT_TOKEN
deck gateway sync kong.yaml
```

## Configuration file

decK can be configured using a `$HOME/.deck.yaml` file in your home directory.

To convert CLI flags to the configuration file format, remove the leading `--` and add a new key in `$HOME/.deck.yaml`

To run the same `deck gateway sync` command as above using the configuation file:

```bash
echo "
konnect-control-plane-name: 15Jan
konnect-token: $KONNECT_TOKEN
" > $HOME/.deck.yaml

deck gateway sync kong.yaml
```