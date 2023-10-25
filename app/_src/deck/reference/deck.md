---
title: deck
source_url: https://github.com/Kong/deck/tree/main/cmd/root.go
content_type: reference
---

The deck tool helps you manage Kong clusters with a declarative
configuration file.

It can be used to export, import, or sync entities to Kong.

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% if_version gte:1.8.x %}
* [deck completion](/deck/{{page.kong_version}}/reference/deck_completion/)	 - Generate completion script
{% endif_version %}
* [deck convert](/deck/{{page.kong_version}}/reference/deck_convert/)	 - Convert files from one format into another format
* [deck diff](/deck/{{page.kong_version}}/reference/deck_diff/)	 - Diff the current entities in Kong with the one on disks
* [deck dump](/deck/{{page.kong_version}}/reference/deck_dump/)	 - Export Kong configuration to a file
{% if_version lte:1.13.x %}
* [deck {{site.konnect_short_name}}](/deck/{{page.kong_version}}/reference/deck_konnect/)	 - Configuration tool for {{site.konnect_short_name}} (in alpha)
{% endif_version %}
* [deck ping](/deck/{{page.kong_version}}/reference/deck_ping/)	 - Verify connectivity with Kong
* [deck reset](/deck/{{page.kong_version}}/reference/deck_reset/)	 - Reset deletes all entities in Kong
* [deck sync](/deck/{{page.kong_version}}/reference/deck_sync/)	 - Sync performs operations to get Kong's configuration to match the state file
* [deck validate](/deck/{{page.kong_version}}/reference/deck_validate/)	 - Validate the state file
* [deck version](/deck/{{page.kong_version}}/reference/deck_version/)	 - Print the decK version
