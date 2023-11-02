---
title: deck diff
content_type: reference
short_desc: The diff command is similar to a dry run of the decK sync command.
---

{% if_version gte:1.28.x %}
{:.warning}
> **Warning**: This command is deprecated and will be removed in a future version.
Use [deck gateway diff](/deck/{{page.kong_version}}/reference/deck_gateway_diff/) instead.
{% endif_version %}

The diff command is similar to a dry run of the 'decK sync' command.

It loads entities from Kong and performs a diff with
the entities in local files. This allows you to see the entities
that will be created, updated, or deleted.


## Syntax

```
deck diff [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for diff 

{% if_version gte:1.16.x %}
`--no-mask-deck-env-vars-value`
:  do not mask `DECK_` environment variable values at diff output. (Default: `false`)
{% endif_version %}

`--non-zero-exit-code`
:  return exit code 2 if there is a diff present,
exit code 0 if no diff is found,
and exit code 1 if an error occurs. (Default: `false`)

`--parallelism`
:  Maximum number of concurrent operations. (Default: `10`)

`--rbac-resources-only`
:  sync only the RBAC resources **{{site.ee_product_name}} only**. (Default: `false`)

`--select-tag`
:  only entities matching tags specified via this flag are diffed.
When this setting has multiple tag values, entities must match each of them.

{% if_version gte:1.8.x %}

`--silence-events`
:  disable printing events to stdout (Default: `false`)

{% endif_version %}

{% if_version gte:1.12.x %}

`--skip-ca-certificates`
:  do not diff CA certificates. (Default: `false`)

{% endif_version %}

`--skip-consumers`
:  do not diff consumers or any plugins associated with consumers (Default: `false`)

`-s`, `--state`
:  file(s) containing Kong's configuration.
This flag can be specified multiple times for multiple files.
Use `-` to read from stdin. (Default: `[kong.yaml]`)

`-w`, `--workspace`
:  Diff configuration with a specific workspace ({{site.ee_product_name}} only).
This takes precedence over _workspace fields in state files.


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
