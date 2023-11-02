---
title: deck gateway reset
source_url: https://github.com/Kong/deck/tree/main/cmd/gateway_reset.go
content_type: reference
---

The reset command deletes all entities in Kong's `database.string`.

Use this command with extreme care as it's equivalent to running
`kong migrations reset` on your Kong instance.

By default, this command will ask for confirmation.

## Syntax

```
deck gateway reset [command-specific flags] [global flags]
```

## Flags

`--all-workspaces`
:  reset configuration of all workspaces ({{site.ee_product_name}} only). (Default: `false`)

`-f`, `--force`
:  Skip interactive confirmation prompt before reset. (Default: `false`)

`-h`, `--help`
:  help for reset 

`--json-output`
:  generate command execution report in a JSON format (Default: `false`)

`--no-mask-deck-env-vars-value`
:  do not mask DECK_ environment variable values in the diff output. (Default: `false`)

`--rbac-resources-only`
:  reset only the RBAC resources ({{site.ee_product_name}} only). (Default: `false`)

`--select-tag`
:  only entities matching tags specified via this flag are deleted.
When this setting has multiple tag values, entities must match every tag.

`--skip-ca-certificates`
:  do not reset CA certificates. (Default: `false`)

`--skip-consumers`
:  do not reset consumers, consumer-groups or any plugins associated with consumers. (Default: `false`)

`-w`, `--workspace`
:  reset configuration of a specific workspace ({{site.ee_product_name}} only).



## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md gateway_links='true' %}
