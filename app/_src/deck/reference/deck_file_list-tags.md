---
title: deck file list-tags
source_url: https://github.com/Kong/deck/tree/main/cmd/file_listtags.go
content_type: reference
---

List current tags from objects in a decK file.

The tags are collected from all objects that match the selector expressions. If no
selectors are given, all Kong entities are scanned.

## Syntax

```
deck file list-tags [command-specific flags] [global flags]
```

## Examples

```
# list all tags used on services
cat kong.yml | deck file list-tags --selector='services[*]'
```

## Flags

`--format`
:  Output format: JSON, YAML, or PLAIN. (Default: `"PLAIN"`)

`-h`, `--help`
:  Help for list-tags.

`-o`, `--output-file`
:  Output file to write to. Use `-` to write to stdout. (Default: `"-"`)

`--selector`
:  JSON path expression to select objects to scan for tags.
Defaults to all Kong entities. Repeat for multiple selectors.

{:.important}
> **Warning**: The JSONPath implementation has a known issue related to 
recursive descent with expressions. Expressions following a recursive
descent do not work as expected, however, a workaround is available by preceding the
expression with a wildcard selection. For example, `$..plugins[?(@.regex_priority>100)]` must
be expressed as `$..plugins[*][?(@.regex_priority>100)]`. See the 
[go-apiops library documentation](https://github.com/Kong/go-apiops/blob/main/docs/README.md#notes) 
for details on this issue.

`-s`, `--state`
:  decK file to process. Use `-` to read from stdin. (Default: `"-"`)


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}

