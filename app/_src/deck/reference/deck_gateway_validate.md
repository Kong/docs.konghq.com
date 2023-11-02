---
title: deck gateway validate
source_url: https://github.com/Kong/deck/tree/main/cmd/gateway_validate.go
content_type: reference
---

The validate command reads the state file and ensures validity.
It reads all the specified state files and reports YAML/JSON
parsing issues. It also checks for foreign relationships
and alerts if there are broken relationships, or missing links present.

Validates against the Kong API, via communication with Kong. This increases the
time for validation but catches significant errors. No resource is created in Kong.
For offline validation, see `deck file validate`.


## Syntax

```
deck gateway validate [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for validate 

`--json-output`
:  generate command execution report in a JSON format (Default: `false`)

`--parallelism`
:  Maximum number of concurrent requests to Kong. (Default: `10`)

`--rbac-resources-only`
:  indicate that the state file(s) contains RBAC resources only ({{site.ee_product_name}} only). (Default: `false`)

`-w`, `--workspace`
:  validate configuration of a specific workspace ({{site.ee_product_name}} only).
This takes precedence over _workspace fields in state files.


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md gateway_links='true' %}

