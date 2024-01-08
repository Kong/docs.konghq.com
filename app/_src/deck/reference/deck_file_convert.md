---
title: deck file convert
source_url: https://github.com/Kong/deck/tree/main/cmd/file_convert.go
content_type: reference
---

The convert command changes configuration files from one format
into another compatible format. For example, a configuration for 'kong-gateway-2.x'
can be converted into a 'kong-gateway-3.x' configuration file.

## Syntax

```
deck file convert [command-specific flags] [global flags]
```

## Flags

`--format`
:  output file format: json or yaml. (Default: `"yaml"`)

`--from`
:  format of the source file, allowed formats: [kong-gateway kong-gateway-2.x]

`-h`, `--help`
:  help for convert 

`--input-file`
:  configuration file to be converted. Use `-` to read from stdin. (Default: `"-"`)

`-o`, `--output-file`
:  file to write configuration to after conversion. Use `-` to write to stdout. (Default: `"-"`)

`--to`
:  desired format of the output, allowed formats: [konnect kong-gateway-3.x]

`--yes`
:  assume `yes` to prompts and run non-interactively. (Default: `false`)



## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}

