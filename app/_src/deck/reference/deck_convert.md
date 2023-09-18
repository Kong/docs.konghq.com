---
title: deck convert
source_url: https://github.com/Kong/deck/tree/main/cmd/convert.go
content_type: reference
---

The convert command changes configuration files from one format
into another compatible format. For example, a configuration for `kong-gateway`
can be converted into a `konnect` configuration file.

## Syntax

```
deck convert [command-specific flags] [global flags]
```

## Flags

`--from`
:  format of the source file, allowed formats:
{% if_version gte:1.15.x %}[`kong-gateway` `kong-gateway-2.x`]{% endif_version %}{%
   if_version gte:1.7.x lte:1.14.x %}`kong-gateway`{% endif_version %}

`-h`, `--help`
:  help for convert (Default: `false`)

`--input-file`
:  configuration file to be converted. Use `-` to read from stdin.

`--output-file`
:  file to write configuration to after conversion. Use `-` to write to stdout.
   {% if_version gte:1.16.x %} (Default: `"kong.yaml"`){% endif_version %}

`--to`
:  desired format of the output, allowed formats:
{% if_version gte:1.15.x %}[`konnect` `kong-gateway-3.x`]{% endif_version %}{%
   if_version gte:1.7.x lte:1.14.x %}`konnect`{% endif_version %}

{% if_version gte: 1.16.x %}
`--yes`
:  assume `yes` to prompts and run non-interactively. (Default: `false`)
{% endif_version %}

## Global flags

{% include_cached /md/deck-global-flags.md %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
