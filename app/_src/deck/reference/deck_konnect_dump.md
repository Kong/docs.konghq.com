---
title: deck konnect dump
source_url: https://github.com/Kong/deck/tree/main/cmd/konnect_dump.go
content_type: reference
---

The `konnect dump` command reads all entities present in {{site.konnect_short_name}}
and writes them to a local file.

The file can then be read using the `deck konnect sync` command or `deck konnect diff` command to
configure {{site.konnect_short_name}}.

{:.important}
> **Deprecation notice:** The `deck konnect` command has been deprecated as of
v1.12. Please use `deck <cmd>` instead if you would like to declaratively
manage your {{site.base_gateway}} config with {{site.konnect_short_name}}.

## Syntax

```
deck konnect dump [command-specific flags] [global flags]
```

## Flags

`--format`
:  output file format: json or yaml. (Default: `"yaml"`)

`-h`, `--help`
:  help for dump 

`--include-consumers`
:  export consumers, associated credentials and any plugins associated with consumers. (Default: `false`)

`-o`, `--output-file`
:  file to which to write Kong's configuration. (Default: `"konnect"`)

`--with-id`
:  write ID of all entities in the output. (Default: `false`)

`--yes`
:  Assume `yes` to prompts and run non-interactively. (Default: `false`)


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [decK {{site.konnect_short_name}}](/deck/{{page.kong_version}}/reference/deck_konnect/)	 - Configuration tool for {{site.konnect_short_name}} (in alpha)
