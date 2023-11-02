---
title: deck file add-tags
source_url: https://github.com/Kong/deck/tree/main/cmd/file_addtags.go
content_type: reference
---

Add tags to objects in a decK file.

The tags are added to all objects that match the selector expressions. If no
selectors are given, all Kong entities are tagged.

## Syntax

```
deck file add-tags [command-specific flags] [global flags] tag [...tag]
```

## Examples

```
# adds tags 'tag1' and 'tag2' to all services in file 'kong.yml'
cat kong.yml | deck file add-tags --selector='services[*]' tag1 tag2
```

## Flags

`--format`
:  Output format: JSON or YAML. (Default: `"YAML"`)

`-h`, `--help`
:  Help for add-tags.

`-o`, `--output-file`
:  Output file to write. Use `-` to write to stdout. (Default: `"-"`)

`--selector`
:  JSON path expression to select objects to add tags to. 
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


