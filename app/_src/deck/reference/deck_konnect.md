---
title: deck konnect
source_url: https://github.com/Kong/deck/tree/main/cmd/konnect.go
content_type: reference
---

The {{site.konnect_short_name}} command prints subcommands that can be used to
configure {{site.konnect_short_name}}.

{:.important}
> **Deprecation notice:** The `deck konnect` command has been deprecated as of
v1.12. Please use `deck <cmd>` instead if you would like to declaratively
manage your {{site.base_gateway}} config with {{site.konnect_short_name}}.

## Flags

`-h`, `--help`
:  help for {{site.konnect_short_name}} (Default: `false`)

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

* [deck](/deck/{{page.release}}/reference/deck/)	 - Administer your Kong clusters declaratively
* [deck {{site.konnect_short_name}} diff](/deck/{{page.release}}/reference/deck_konnect_diff/)	 - Diff the current entities in Konnect with the one on disks (in alpha)
* [deck {{site.konnect_short_name}} dump](/deck/{{page.release}}/reference/deck_konnect_dump/)	 - Export configuration from Konnect (in alpha)
* [deck {{site.konnect_short_name}} ping](/deck/{{page.release}}/reference/deck_konnect_ping/)	 - Verify connectivity with Konnect (in alpha)
* [deck {{site.konnect_short_name}} sync](/deck/{{page.release}}/reference/deck_konnect_sync/)	 - Sync performs operations to get Konnect's configuration to match the state file (in alpha)
