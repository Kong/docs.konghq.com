---
title: deck gateway ping
source_url: https://github.com/Kong/deck/tree/main/cmd/gateway_ping.go
content_type: reference
---

The ping command can be used to verify if decK
can connect to Kong's Admin API.

## Syntax

```
deck gateway ping [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  Help for ping.

`-w`, `--workspace`
:  Ping configuration with a specific workspace ({{site.ee_product_name}} only).
Useful when RBAC permissions are scoped to a workspace.


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md gateway_links='true' %}

