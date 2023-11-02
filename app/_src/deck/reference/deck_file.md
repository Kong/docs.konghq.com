---
title: deck file
source_url: https://github.com/Kong/deck/tree/main/cmd/file.go
content_type: reference
---

Subcommand to host the decK file manipulation operations.

## Flags

`-h`, `--help`
:  Help for file.

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## decK file commands

* [deck file add-plugins](/deck/{{page.kong_version}}/reference/deck_file_add-plugins)	 - Add plugins to objects in a decK file
* [deck file add-tags](/deck/{{page.kong_version}}/reference/deck_file_add-tags)	 - Add tags to objects in a decK file
{% if_version gte:1.28.x %}
* [deck file convert](/deck/{{page.kong_version}}/reference/deck_file_convert)	 - Convert files from one format into another format
* [deck file lint](/deck/{{page.kong_version}}/reference/deck_file_lint)	 - Lint a file against a ruleset
{% endif_version %}
* [deck file list-tags](/deck/{{page.kong_version}}/reference/deck_file_list-tags)	 - List current tags from objects in a decK file
* [deck file merge](/deck/{{page.kong_version}}/reference/deck_file_merge)	 - Merge multiple decK files into one
* [deck file openapi2kong](/deck/{{page.kong_version}}/reference/deck_file_openapi2kong)	 - Convert OpenAPI files to Kong's decK format
* [deck file patch](/deck/{{page.kong_version}}/reference/deck_file_patch)	 - Apply patches on top of a decK file
* [deck file remove-tags](/deck/{{page.kong_version}}/reference/deck_file_remove-tags)	 - Remove tags from objects in a decK file
{% if_version gte:1.28.x %}
* [deck file render](/deck/{{page.kong_version}}/reference/deck_file_render)	 - Combines multiple complete configuration files and renders them as one Kong declarative config file.
* [deck file validate](/deck/{{page.kong_version}}/reference/deck_file_validate)	 - Validate the state file locally
{% endif_version %}
