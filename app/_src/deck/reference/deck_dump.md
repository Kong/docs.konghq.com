---
title: deck dump
source_url: https://github.com/Kong/deck/tree/main/cmd/dump.go
content_type: reference
---

The dump command reads all entities present in Kong
and writes them to a local file.

The file can then be read using the sync command or diff command to
configure Kong.

## Syntax

```
deck dump [command-specific flags] [global flags]
```

## Flags

`--all-workspaces`
:  dump configuration of all Workspaces (Kong Enterprise only). (Default: `false`)

`--format`
:  output file format: json or yaml. (Default: `"yaml"`)

`-h`, `--help`
:  help for dump (Default: `false`)

`-o`, `--output-file`
:  file to which to write Kong's configuration.Use `-` to write to stdout. (Default: `"kong"`)

`--rbac-resources-only`
:  export only the RBAC resources (Kong Enterprise only). (Default: `false`)

`--select-tag`
:  only entities matching tags specified with this flag are exported.
When this setting has multiple tag values, entities must match every tag.

{% if_version gte:1.12.x %}

`--skip-ca-certificates`
:  do not dump CA certificates. (Default: `false`)

{% endif_version %}

{% if_version lte:1.18.x %}

`--skip-consumers`
:  skip exporting consumers and any plugins associated with consumers. (Default: `false`)

{% endif_version %}

{% if_version gte:1.19.x %}

`--skip-consumers`
:  skip exporting consumers, consumer-groups, and any plugins associated with them. (Default: `false`)

{% endif_version %}

`--with-id`
:  write ID of all entities in the output (Default: `false`)

`-w`, `--workspace`
:  dump configuration of a specific Workspace(Kong Enterprise only).

`--yes`
:  assume `yes` to prompts and run non-interactively. (Default: `false`)

## Global flags

{% include_cached /md/deck-global-flags.md %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
