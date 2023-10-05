---
title: deck reset
source_url: https://github.com/Kong/deck/tree/main/cmd/reset.go
content_type: reference
---

The reset command deletes all entities in Kong's database.string.

Use this command with extreme care as it's equivalent to running
`kong migrations reset` on your Kong instance.

By default, this command will ask for confirmation.

## Syntax

```
deck reset [command-specific flags] [global flags]
```

## Flags

`--all-workspaces`
:  reset configuration of all workspaces (Kong Enterprise only). (Default: `false`)

`-f`, `--force`
:  Skip interactive confirmation prompt before reset. (Default: `false`)

`-h`, `--help`
:  help for reset (Default: `false`)

{% if_version gte:1.16.x %}
`--no-mask-deck-env-vars-value`
:  do not mask `DECK_` environment variable values at diff output. (Default: `false`)
{% endif_version %}

`--rbac-resources-only`
:  reset only the RBAC resources (Kong Enterprise only). (Default: `false`)

`--select-tag`
:  only entities matching tags specified via this flag are deleted.
When this setting has multiple tag values, entities must match every tag.

{% if_version gte:1.8.x %}

`--skip-ca-certificates`
:  do not reset CA certificates. (Default: `false`)

{% endif_version %}

{% if_version lte:1.18.x %}

`--skip-consumers`
:  do not reset consumers or any plugins associated with consumers. (Default: `false`)

{% endif_version %}

{% if_version gte:1.19.x %}

`--skip-consumers`
:   do not reset consumers, consumer-groups, or any plugins associated with them. (Default: `false`)

{% endif_version %}

`-w`, `--workspace`
:  reset configuration of a specific workspace(Kong Enterprise only).

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
