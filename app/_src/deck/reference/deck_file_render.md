---
title: deck file render
source_url: https://github.com/Kong/deck/tree/main/cmd/file_render.go
---

Combines multiple complete configuration files and renders them as one Kong
declarative config file.

This command renders a full declarative configuration in JSON or YAML format by assembling 
multiple files and populating defaults and environment substitutions. 
This command is useful to observe what configuration would be sent prior to synchronizing to 
the gateway.
 
In comparison to the `deck file merge` command, the render command accepts 
complete configuration files, while `deck file merge` can operate on partial files.

For example, the following command takes two input files and renders them as one 
combined JSON file:

```sh
deck file render kong1.yml kong2.yml -o kong3 --format json
```

## Syntax

```
deck file render [command-specific flags] [global flags]
```

## Flags

`--format`
:  Output file format: json or yaml. (Default: `"yaml"`)

`-h`, `--help`
:  Help for render.

`-o`, `--output-file`
:  File to which to write Kong's configuration. Use `-` to write to stdout. (Default: `"-"`)


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


