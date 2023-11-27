---
title: deck konnect diff
source_url: https://github.com/Kong/deck/tree/main/cmd/konnect_diff.go
content_type: reference
---

The {{site.konnect_short_name}} diff command is similar to a dry run of the `deck konnect sync` command.

It loads entities from {{site.konnect_short_name}} and performs a diff with
the entities in local files. This allows you to see the entities
that will be created, updated, or deleted.

{:.important}
> **Deprecation notice:** The `deck konnect` command has been deprecated as of
v1.12. Please use `deck <cmd>` instead if you would like to declaratively
manage your {{site.base_gateway}} config with {{site.konnect_short_name}}.

## Syntax

```
deck konnect diff [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for diff 

{% if_version gte:1.16.x %}
`--no-mask-deck-env-vars-value`
:  do not mask `DECK_` environment variable values in the diff output. 
{% endif_version %}

`--include-consumers`
:  export consumers, associated credentials and any plugins associated with consumers. 

`--non-zero-exit-code`
:  return exit code 2 if there is a diff present,
exit code 0 if no diff is found,
and exit code 1 if an error occurs. 

`--parallelism`
:  Maximum number of concurrent operations. (Default: `100`)

{% if_version gte:1.8.x %}

`--silence-events`
:  disable printing events to stdout 

{% endif_version %}

`-s`, `--state`
:  file(s) containing {{site.konnect_short_name}}'s configuration.
This flag can be specified multiple times for multiple files. (Default: `[konnect.yaml]`)


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [decK {{site.konnect_short_name}}](/deck/{{page.kong_version}}/reference/deck_konnect/)	 - Configuration tool for {{site.konnect_short_name}} (in alpha)
