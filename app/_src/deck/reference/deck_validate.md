---
title: deck validate
content_type: reference
---

{% if_version gte:1.28.x %}
{:.warning}
> **Warning**: This command is deprecated and will be removed in a future version.
Use [deck gateway validate](/deck/{{page.kong_version}}/reference/deck_gateway_validate/) instead.
{% endif_version %}

The validate command reads the state file and ensures validity.
It reads all the specified state files and reports YAML/JSON
parsing issues. It also checks for foreign relationships
and alerts if there are broken relationships, or missing links present.

No communication takes places between decK and Kong during the execution of
this command unless --online flag is used.


## Syntax

```
deck validate [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for validate 

{% if_version gte:1.11.x %}


`--online`
:  perform validations against Kong API. When this flag is used, validation is done
via communication with Kong. This increases the time for validation but catches
significant errors. No resource is created in Kong. (Default: `false`)


`--parallelism`
:  Maximum number of concurrent requests to Kong. (Default: `10`)

{% endif_version %}

`--rbac-resources-only`
:  indicate that the state file(s) contains RBAC resources only ({{site.ee_product_name}} only). (Default: `false`)

`-s`, `--state`
:  file(s) containing Kong's configuration.
This flag can be specified multiple times for multiple files.
Use '-' to read from stdin. (Default: `[kong.yaml]`)

{% if_version gte:1.11.x %}

`-w`, `--workspace`
:  validate configuration of a specific workspace ({{site.ee_product_name}} only).
This takes precedence over _workspace fields in state files.

{% endif_version %}

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
