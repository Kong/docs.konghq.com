---
title: deck file openapi2kong
source_url: https://github.com/Kong/deck/tree/main/cmd/file_openapi2kong.go
content_type: reference
---

Convert OpenAPI files to Kong's decK format.

The example file at [Kong/go-apiops](https://github.com/Kong/go-apiops/blob/main/docs/learnservice_oas.yaml)
has extensive annotations explaining the conversion process, as well as all supported 
custom annotations (`x-kong-...` directives).

## Syntax

```
deck file openapi2kong [command-specific flags] [global flags]
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

* [deck file](/deck/{{page.kong_version}}/reference/deck_file)	 - Sub-command to host the decK file manipulation operations

