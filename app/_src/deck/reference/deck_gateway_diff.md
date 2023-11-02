---
title: deck gateway diff
source_url: https://github.com/Kong/deck/tree/main/cmd/gateway_diff.go
content_type: reference
---

The diff command is similar to a dry run of the `deck gateway sync` command.

It loads entities from Kong and performs a diff with
the entities in local files. This allows you to see the entities
that will be created, updated, or deleted.


## Syntax

```
deck gateway diff [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for diff 

`--json-output`
:  generate command execution report in a JSON format (Default: `false`)

`--no-mask-deck-env-vars-value`
:  do not mask DECK_ environment variable values in the diff output. (Default: `false`)

`--non-zero-exit-code`
:  return exit code 2 if there is a diff present,
exit code 0 if no diff is found,
and exit code 1 if an error occurs. (Default: `false`)

`--parallelism`
:  Maximum number of concurrent operations. (Default: `10`)

`--rbac-resources-only`
:  sync only the RBAC resources ({{site.ee_product_name}} only). (Default: `false`)

`--select-tag`
:  only entities matching tags specified via this flag are diffed.
When this setting has multiple tag values, entities must match each of them.

`--silence-events`
:  disable printing events to stdout (Default: `false`)

`--skip-ca-certificates`
:  do not diff CA certificates. (Default: `false`)

`--skip-consumers`
:  do not diff consumers or any plugins associated with consumers (Default: `false`)

`-w`, `--workspace`
:  Diff configuration with a specific workspace ({{site.ee_product_name}} only).
This takes precedence over _workspace fields in state files.



## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md gateway_links='true' %}
