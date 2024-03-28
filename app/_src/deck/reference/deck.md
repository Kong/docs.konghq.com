---
title: deck
source_url: https://github.com/Kong/deck/tree/main/cmd/root.go
content_type: reference
---

The deck tool helps you manage Kong clusters with a declarative
configuration file.

It can be used to export, import, or sync entities to Kong.

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## decK CLI commands

<!--vale off -->

{% if_version gte:1.28.x %}

{% include /md/deck-reference-links.md general_links='true' gateway_links='true' file_links='true' deprecated_links='true' %}

{% endif_version %}


<!-- ################ PRE 1.28 REFACTORING ################## -->

{% if_version lte:1.27.x %}

{% if_version gte:1.8.x -%}
* [deck completion](/deck/{{page.release}}/reference/deck_completion/)	 - Generate completion script
{% endif_version -%}
* [deck convert](/deck/{{page.release}}/reference/deck_convert/)	 - Convert files from one format into another format
* [deck diff](/deck/{{page.release}}/reference/deck_diff/)	 - Diff the current entities in Kong with the one on disks
* [deck dump](/deck/{{page.release}}/reference/deck_dump/)	 - Export Kong configuration to a file
{% if_version lte:1.13.x -%}
* [deck {{site.konnect_short_name}}](/deck/{{page.release}}/reference/deck_konnect/)	 - Configuration tool for {{site.konnect_short_name}} (in alpha)
{% endif_version -%}
* [deck ping](/deck/{{page.release}}/reference/deck_ping/)	 - Verify connectivity with Kong
* [deck reset](/deck/{{page.release}}/reference/deck_reset/)	 - Reset deletes all entities in Kong
* [deck sync](/deck/{{page.release}}/reference/deck_sync/)	 - Sync performs operations to get Kong's configuration to match the state file
* [deck validate](/deck/{{page.release}}/reference/deck_validate/)	 - Validate the state file
* [deck version](/deck/{{page.release}}/reference/deck_version/)	 - Print the decK version
{% if_version gte:1.24.x -%}
* [deck file](/deck/{{page.release}}/reference/deck_file_add-plugins)	 - Subcommand to host the decK file operations
* [deck file add-plugins](/deck/{{page.release}}/reference/deck_file_add-plugins)	 - Add plugins to objects in a decK file
* [deck file add-tags](/deck/{{page.release}}/reference/deck_file_add-tags)	 - Add tags to objects in a decK file
* [deck file list-tags](/deck/{{page.release}}/reference/deck_file_list-tags)	 - List current tags from objects in a decK file
* [deck file merge](/deck/{{page.release}}/reference/deck_file_merge)	 - Merge multiple decK files into one
* [deck file openapi2kong](/deck/{{page.release}}/reference/deck_file_openapi2kong)	 - Convert OpenAPI files to Kong's decK format
* [deck file patch](/deck/{{page.release}}/reference/deck_file_patch)	 - Apply patches on top of a decK file
* [deck file remove-tags](/deck/{{page.release}}/reference/deck_file_remove-tags)	 - Remove tags from objects in a decK file
{% endif_version %}

{% endif_version %}
