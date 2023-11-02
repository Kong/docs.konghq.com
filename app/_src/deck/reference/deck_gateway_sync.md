---
title: deck gateway sync
source_url: https://github.com/Kong/deck/tree/main/cmd/gateway_sync.go
content_type: reference
---

The sync command reads the state file and performs operation on Kong
to get Kong's state in sync with the input state.

## Syntax

```
deck gateway sync [command-specific flags] [global flags]
```

## Flags

`--db-update-propagation-delay`
:  artificial delay (in seconds) that is injected between insert operations 
for related entities (usually for Cassandra deployments).
See `db_update_propagation` in kong.conf. (Default: `0`)

`-h`, `--help`
:  help for sync 

`--json-output`
:  generate command execution report in a JSON format (Default: `false`)

`--no-mask-deck-env-vars-value`
:  do not mask DECK_ environment variable values in the diff output. (Default: `false`)

`--parallelism`
:  Maximum number of concurrent operations. (Default: `10`)

`--rbac-resources-only`
:  diff only the RBAC resources ({{site.ee_product_name}} only). (Default: `false`)

`--select-tag`
:  only entities matching tags specified via this flag are synced.
When this setting has multiple tag values, entities must match every tag.
All entities in the state file will get the select-tags assigned if not present already.

`--silence-events`
:  disable printing events to stdout (Default: `false`)

`--skip-ca-certificates`
:  do not sync CA certificates. (Default: `false`)

`--skip-consumers`
:  do not sync consumers, consumer-groups or any plugins associated with them. (Default: `false`)

`-w`, `--workspace`
:  Sync configuration to a specific workspace ({{site.ee_product_name}} only).
This takes precedence over _workspace fields in state files.



## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md gateway_links='true' %}
