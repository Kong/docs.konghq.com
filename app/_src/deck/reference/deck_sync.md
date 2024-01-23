---
title: deck sync
content_type: reference
---

{% if_version gte:1.28.x %}
{:.important}
> `deck sync` functionality has moved to `deck gateway sync`. 
> <br> `deck sync` will be removed in a future major version of decK (decK 2.x).
We recommend migrating to [deck gateway sync](/deck/{{ page.release }}/reference/deck_gateway_sync/).
> <br><br> In the new command:
> * Files changed to positional arguments without the `-s/--state` flag
> * The default write location changed from `kong.yaml` to `-` (stdin/stdout)
{% endif_version %}

The sync command reads the state file and performs operation on Kong
to get Kong's state in sync with the input state.

## Syntax

```
deck sync [command-specific flags] [global flags]
```

## Flags

`--db-update-propagation-delay`
:  artificial delay (in seconds) that is injected between insert operations
for related entities (usually for Cassandra deployments).
See `db_update_propagation` in `kong.conf`. (Default: `0`)

`-h`, `--help`
:  help for sync 

{% if_version gte:1.16.x %}
`--no-mask-deck-env-vars-value`
:  do not mask `DECK_` environment variable values at diff output. (Default: `false`)
{% endif_version %}

`--parallelism`
:  Maximum number of concurrent operations. (Default: `10`)

`--rbac-resources-only`
:  diff only the RBAC resources ({{site.ee_product_name}} only). (Default: `false`)

`--select-tag`
:  only entities matching tags specified via this flag are synced.
When this setting has multiple tag values, entities must match every tag.

{% if_version gte:1.8.x %}

`--silence-events`
:  disable printing events to stdout (Default: `false`)

{% endif_version %}

{% if_version gte:1.12.x %}

`--skip-ca-certificates`
:  do not sync CA certificates. (Default: `false`)

{% endif_version %}

{% if_version lte:1.18.x %}

`--skip-consumers`
:  do not sync consumers or any plugins associated with consumers. (Default: `false`)

{% endif_version %}

{% if_version gte:1.19.x %}

`--skip-consumers`
:   do not sync consumers, consumer-groups, or any plugins associated with them. (Default: `false`)

{% endif_version %}

`-s`, `--state`
:  file(s) containing Kong's configuration.
This flag can be specified multiple times for multiple files.
Use `-` to read from stdin. (Default: `[kong.yaml]`)


{% if_version gte:1.16.x %} `-w`,{% endif_version %} `--workspace`
:  Sync configuration to a specific workspace ({{site.ee_product_name}} only).
This takes precedence over `_workspace` fields in state files.

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

* [deck](/deck/{{page.release}}/reference/deck/)	 - Administer your Kong clusters declaratively
