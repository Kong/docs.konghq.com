---
title: deck konnect ping
source_url: https://github.com/Kong/deck/tree/main/cmd/konnect_ping.go
content_type: reference
---

The {{site.konnect_short_name}} ping command can be used to verify if decK
can connect to {{site.konnect_short_name}}'s API endpoint. It also validates the supplied
credentials.

{:.important}
> **Deprecation notice:** The `deck konnect` command has been deprecated as of
v1.12. Please use `deck <cmd>` instead if you would like to declaratively
manage your {{site.base_gateway}} config with {{site.konnect_short_name}}.

## Syntax

```
deck konnect ping [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for ping 

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [decK {{site.konnect_short_name}}](/deck/{{page.kong_version}}/reference/deck_konnect/)	 - Configuration tool for {{site.konnect_short_name}} (in alpha)
