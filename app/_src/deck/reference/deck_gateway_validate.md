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

{:.note}
> `deck gateway validate` is the replacement for `deck validate`. 
> <br><br> In `deck gateway validate`, the following has changed:
> * Files changed to positional arguments without the `-s/--state` flag
> * The default write location changed from `kong.yaml` to `-` (stdin/stdout)
> * The `--online` flag is removed, use either `deck file` or `deck gateway`

## Syntax

```
deck gateway validate [filename] [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for validate 

{% if_version gte:1.37.x %}
`--konnect-compatibility`
:  validate that the state file(s) are ready to be deployed to Konnect (Default: `false`)
{% endif_version %}

{% if_version gte:1.42.x %}
`--online-entities-list`
: Specify the list of valid Kong entities (case-sensitive) to be validated online.
This indicates which entities in the state file(s) should be checked via online validation.
{% endif_version %}

`--parallelism`
:  Maximum number of concurrent requests to Kong. (Default: `10`)

`--rbac-resources-only`
:  indicate that the state file(s) contains RBAC resources only ({{site.ee_product_name}} only). (Default: `false`)

`-w`, `--workspace`
:  validate configuration of a specific workspace ({{site.ee_product_name}} only).
This takes precedence over _workspace fields in state files.


## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

{% include /md/deck-reference-links.md gateway_links='true' %}

