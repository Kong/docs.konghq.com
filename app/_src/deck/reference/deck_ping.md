---
title: deck ping
source_url: https://github.com/Kong/deck/tree/main/cmd/ping.go
content_type: reference
---

The ping command can be used to verify if decK
can connect to Kong's Admin API.

## Syntax

```
deck ping [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for ping (Default: `false`)

`-w`, `--workspace`
:  Ping configuration with a specific Workspace (Kong Enterprise only).
Useful when RBAC permissions are scoped to a Workspace.

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
