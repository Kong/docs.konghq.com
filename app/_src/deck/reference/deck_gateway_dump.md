---
title: deck gateway dump
source_url: https://github.com/Kong/deck/tree/main/cmd/gateway_dump.go
content_type: reference
---

The dump command reads all entities present in Kong
and writes them to a local file.

The file can then be read using the sync command or diff command to
configure Kong.

## Syntax

```
deck gateway dump [command-specific flags] [global flags]
```

## Flags

`--all-workspaces`
:  dump configuration of all Workspaces ({{site.ee_product_name}} only). (Default: `false`)

`--format`
:  output file format: json or yaml. (Default: `"yaml"`)

`-h`, `--help`
:  help for dump 

`-o`, `--output-file`
:  file to which to write Kong's configuration.Use `-` to write to stdout. (Default: `"-"`)

`--rbac-resources-only`
:  export only the RBAC resources ({{site.ee_product_name}} only). (Default: `false`)

`--select-tag`
:  only entities matching tags specified with this flag are exported.
When this setting has multiple tag values, entities must match every tag.

`--skip-ca-certificates`
:  do not dump CA certificates. (Default: `false`)

`--skip-consumers`
:  skip exporting consumers, consumer-groups and any plugins associated with them. (Default: `false`)

`--with-id`
:  return the ID of all entities in the output (Default: `false`)

`-w`, `--workspace`
:  dump configuration of a specific workspace. **{{site.ee_product_name}} only**.

`--yes`
:  assume `yes` to prompts and run non-interactively. (Default: `false`)



## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md gateway_links='true' %}
