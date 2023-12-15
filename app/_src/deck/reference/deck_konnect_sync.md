---
title: deck konnect sync
source_url: https://github.com/Kong/deck/tree/main/cmd/konnect_sync.go
content_type: reference
---

The {{site.konnect_short_name}} sync command reads the state file and performs operations in {{site.konnect_short_name}}
to get {{site.konnect_short_name}}'s state in sync with the input state.

{:.important}
> **Deprecation notice:** The `deck konnect` command has been deprecated as of
v1.12. Please use `deck <cmd>` instead if you would like to declaratively
manage your {{site.base_gateway}} config with {{site.konnect_short_name}}.

## Syntax

```
deck konnect sync [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for sync 

`--include-consumers`
:  export consumers, associated credentials and any plugins associated with consumers. (Default: `false`)

{% if_version gte:1.16.x %}
`--no-mask-deck-env-vars-value`
:  do not mask `DECK_` environment variable values at diff output. (Default: `false`)
{% endif_version %}

`--parallelism`
:  Maximum number of concurrent operations. (Default: `100`)

{% if_version gte:1.8.x %}

`--silence-events`
:  disable printing events to stdout (Default: `false`)

{% endif_version %}

`-s`, `--state`
:  file(s) containing {{site.konnect_short_name}}'s configuration.
This flag can be specified multiple times for multiple files. (Default: `[konnect.yaml]`)

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [Deck {{site.base_gateway}}](/deck/{{page.kong_version}}/reference/deck_konnect/)	 - Configuration tool for {{site.konnect_short_name}} (in alpha)
