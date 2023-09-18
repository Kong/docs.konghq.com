---
title: deck file render
source_url: https://github.com/Kong/deck/tree/main/cmd/file_render.go
---

Render the configuration as Kong declarative config.

## Syntax

```
deck file render [command-specific flags] [global flags]
```

## Flags

`--format`
:  Output file format: json or yaml. (Default: `"yaml"`)

`-h`, `--help`
:  Help for render. (Default: `false`)

`-o`, `--output-file`
:  File to which to write Kong's configuration. Use `-` to write to stdout. (Default: `"-"`)


## Global flags

{% include_cached /md/deck-global-flags.md %}

## See also

* [deck file](/deck/{{page.kong_version}}/reference/deck_file)	 - Subcommand to host the decK file manipulation operations

