---
title: Configuration
---

decK can be configured using CLI flags, environment variables and a configuration file on disk.

* CLI flags override all other values
* Environment variables override the configuration file
* Configuration file values are treated as defaults

## CLI Flags

To view the available CLI flags for a command, run `deck <command> --help`. These flags can be provided when running the command e.g.

```bash
deck gateway sync --konnect-control-plane-name demo --konnect-token $KONNECT_TOKEN kong.yaml
```

## Environment Variables

All CLI flags may also be provided as environment variables.

To determine the environment variable name, replace the `.` and `-` characters in the CLI flag with `_` and prefix it with `DECK_`.

To run the same `deck gateway sync` command as above using enviroment variables:

```bash
export DECK_KONNECT_CONTROL_PLANE_NAME=demo
export DECK_KONNECT_TOKEN=$KONNECT_TOKEN
deck gateway sync kong.yaml
```

## Configuration File

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