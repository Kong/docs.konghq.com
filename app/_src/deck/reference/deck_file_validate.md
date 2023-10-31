---
title: deck file validate
source_url: https://github.com/Kong/deck/tree/main/cmd/file_validate.go
content_type: reference
---

The validate command reads the state file and ensures validity.
It reads all the specified state files and reports YAML/JSON
parsing issues. It also checks for foreign relationships
and alerts if there are broken relationships, or missing links present.

No communication takes places between decK and Kong during the execution of
this command. This is faster than the online validation, but catches fewer errors.
For online validation see 'deck gateway validate'.


## Syntax

```
deck file validate [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  Help for validate

`--json-output`
:  Generate command execution report in a JSON format (Default: `false`)

`--parallelism`
:  Maximum number of concurrent requests to Kong. (Default: `10`)

`--rbac-resources-only`
:  Indicate that the state file(s) contains RBAC resources only ({{site.ee_product_name}} only). (Default: `false`)

`-w`, `--workspace`
:  Validate configuration of a specific workspace ({{site.ee_product_name}} only).
This takes precedence over `_workspace` fields in state files.


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck file](/deck/{{page.kong_version}}/reference/deck_file)	 - Subcommand to host the decK file operations

