---
title: deck dump
content_type: reference
---

{% if_version gte:1.28.x %}
{:.warning}
> **Warning**: This command is deprecated and will be removed in a future version.
Use [deck gateway dump](/deck/{{page.kong_version}}/reference/deck_gateway_dump/) instead.
{% endif_version %}

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
:  dump configuration of all workspaces **{{site.ee_product_name}} only**. (Default: `false`)

`--format`
:  output file format: json or yaml. (Default: `"yaml"`)

`-h`, `--help`
:  help for dump 

`-o`, `--output-file`
:  file to which to write Kong's configuration.Use `-` to write to stdout. (Default: `"kong"`)

`--rbac-resources-only`
:  export only the RBAC resources **{{site.ee_product_name}} only**. (Default: `false`)

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
:  dump configuration of a specific workspace **{{site.ee_product_name}} only**.

`--yes`
:  assume `yes` to prompts and run non-interactively. (Default: `false`)

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
