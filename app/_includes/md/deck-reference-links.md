{% if include.general_links == "true" %}
General:
* [deck completion](/deck/{{page.release}}/reference/deck_completion/)	 - Generate completion script
* [deck version](/deck/{{page.release}}/reference/deck_version/) - Print the decK version
{% endif %}

{% if include.gateway_links == "true" %}
Gateway subcommands:
* [deck gateway diff](/deck/{{page.release}}/reference/deck_gateway_diff/)	- Performs a diff to determine the differences between the current entities in Kong and the ones on disk.
* [deck gateway dump](/deck/{{page.release}}/reference/deck_gateway_dump/)	- Export Kong configuration to a file
* [deck gateway ping](/deck/{{page.release}}/reference/deck_gateway_ping/)	- Verify connectivity with Kong
* [deck gateway reset](/deck/{{page.release}}/reference/deck_gateway_reset/) - Deletes all entities in Kong
* [deck gateway sync](/deck/{{page.release}}/reference/deck_gateway_sync/)	- Sync performs operations to get Kong's configuration to match the state file
* [deck gateway validate](/deck/{{page.release}}/reference/deck_gateway_validate/)	- Validate the state file
{% endif %}

{% if include.file_links == "true" %}
File subcommands:
* [deck file add-plugins](/deck/{{page.release}}/reference/deck_file_add-plugins)	 - Add plugins to objects in a decK file
* [deck file add-tags](/deck/{{page.release}}/reference/deck_file_add-tags)	 - Add tags to objects in a decK file
{% if_version gte:1.28.x -%}
* [deck file convert](/deck/{{page.release}}/reference/deck_file_convert)	 - Convert files from one format into another format
{% endif_version -%}
{% if_version gte:1.35.x -%}
* [deck file kong2kic](/deck/{{page.release}}/reference/deck_file_kong2kic)	 - Convert decK state files to Kong Ingress Controller kubernetes manifests.
{% endif_version -%}
{% if_version gte:1.28.x -%}
* [deck file lint](/deck/{{page.release}}/reference/deck_file_lint)	 - Validate a file against a ruleset
{% endif_version -%}
* [deck file list-tags](/deck/{{page.release}}/reference/deck_file_list-tags)	 - List current tags from objects in a decK file
* [deck file merge](/deck/{{page.release}}/reference/deck_file_merge)	 - Merge multiple decK files into one
{% if_version gte:1.34.x -%}
* [deck file namespace](/deck/{{page.release}}/reference/deck_file_namespace)	 - Apply a namespace to routes in a decK file by prefixing the path.
{% endif_version -%}
* [deck file openapi2kong](/deck/{{page.release}}/reference/deck_file_openapi2kong)	 - Convert OpenAPI specifications to Kong's decK format
* [deck file patch](/deck/{{page.release}}/reference/deck_file_patch)	 - Apply patches on top of a decK file
* [deck file remove-tags](/deck/{{page.release}}/reference/deck_file_remove-tags)	 - Remove tags from objects in a decK file
{% if_version gte:1.28.x -%}
* [deck file render](/deck/{{page.release}}/reference/deck_file_render)	 - Combines multiple complete configuration files and renders them as one Kong declarative config file.
* [deck file validate](/deck/{{page.release}}/reference/deck_file_validate)	 - Locally validates the state file for basic structure or relationship errors.
{% endif_version %}
{% endif %}

{% if include.deprecated_links == "true" %}
Deprecated:
* [deck convert](/deck/{{page.release}}/reference/deck_convert/)
* [deck diff](/deck/{{page.release}}/reference/deck_diff/)
* [deck dump](/deck/{{page.release}}/reference/deck_dump/)
* [deck ping](/deck/{{page.release}}/reference/deck_ping/)
* [deck reset](/deck/{{page.release}}/reference/deck_reset/)
* [deck sync](/deck/{{page.release}}/reference/deck_sync/)
* [deck validate](/deck/{{page.release}}/reference/deck_validate/)
{% endif %}
