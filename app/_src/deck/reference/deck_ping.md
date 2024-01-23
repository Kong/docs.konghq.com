---
title: deck ping
content_type: reference
---

{% if_version gte:1.28.x %}
{:.important}
> `deck ping` functionality has moved to `deck gateway ping`. 
> <br>`deck ping` will be removed in a future major version of decK (decK 2.x).
We recommend migrating to [deck gateway ping](/deck/{{ page.release }}/reference/deck_gateway_ping/).
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

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

* [deck](/deck/{{page.release}}/reference/deck/)	 - Administer your Kong clusters declaratively
