---
title: deck ping
content_type: reference
---

{% if_version gte:1.28.x %}
{:.warning}
> **Warning**: This command is deprecated and will be removed in a future version.
Use [deck gateway ping](/deck/{{page.kong_version}}/reference/deck_gateway_ping/) instead.
{% endif_version %}

The ping command can be used to verify if decK
can connect to Kong's Admin API.

## Syntax

```
deck ping [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for ping 

`-w`, `--workspace`
:  Ping configuration with a specific Workspace ({{site.ee_product_name}} only).
Useful when RBAC permissions are scoped to a Workspace.

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
