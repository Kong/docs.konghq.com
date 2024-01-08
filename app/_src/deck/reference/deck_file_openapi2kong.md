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

`-h`, `--help`
:  Help for openapi2kong.

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

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


