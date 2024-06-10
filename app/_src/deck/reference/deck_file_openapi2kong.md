---
title: deck file openapi2kong
source_url: https://github.com/Kong/deck/tree/main/cmd/file_openapi2kong.go
content_type: reference
---

Convert OpenAPI files to Kong's decK format.

{:.important}
> **Important**: Due to compatibility issues with the older `inso` tool, we strongly recommend
using the `--inso-compatible` flag when converting OpenAPI files.

The example file at [Kong/go-apiops](https://github.com/Kong/go-apiops/blob/main/docs/learnservice_oas.yaml)
has extensive annotations explaining the conversion process, as well as all supported 
custom annotations (`x-kong-...` directives).

## Syntax

```
deck file openapi2kong [command-specific flags] [global flags]
```

## Examples

```
# Convert an OAS file, adding 2 tags, with inso compatibility enabled
cat service_oas.yml | deck file openapi2kong --inso-compatible --select-tag=serviceA,teamB
```

## Flags

`--format`
:  Output format: yaml or json. (Default: `"yaml"`)

{% if_version gte:1.30.x %}
`--generate-security`
:  Generate OpenIDConnect plugins from the security directives. (Default: `false`)
{% endif_version %}

`-h`, `--help`
:  Help for openapi2kong.

{% if_version gte:1.30.x %}
`--ignore-security-errors`
: Ignore errors for unsupported security schemes. (Default: `false`)
{% endif_version %}

{% if_version gte:1.28.x %}
`-i`, `--inso-compatible`
:  This flag will enable Inso compatibility. The generated entity names will be the same, and no `id` fields will be generated. (Default: `false`)

`--no-id`
:  Setting this flag will skip UUID generation for entities (no `id` fields will be added, implicit if `--inso-compatible` is set). (Default: `false`)
{% endif_version %}

`-o`, `--output-file`
:  Output file to write to. Use `-` to write to stdout. (Default: `"-"`)

`--select-tag`
:  Select tags to apply to all entities. If omitted, uses the `"x-kong-tags"`
directive from the file.

`-s`, `--spec`
:  OpenAPI spec file to process. Use `-` to read from stdin. (Default: `"-"`)

`--uuid-base`
:  The unique base-string for uuid-v5 generation of entity IDs. If omitted,
uses the root-level `"x-kong-name"` directive, or falls back to `info.title`.

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


