---
title: deck file merge
source_url: https://github.com/Kong/deck/tree/main/cmd/file_merge.go
content_type: reference
---

Merge multiple decK files into one.

The files can be in either JSON or YAML format. Merges all top-level arrays by
concatenating them. Any other keys are copied. The files are processed in the order
provided. 

Doesn't perform any checks on content, e.g. duplicates, or any validations.

If the input files are not compatible, returns an error. Compatibility is
determined by the `_transform` and `_format_version` fields.

## Syntax

```
deck file merge [command-specific flags] [global flags] filename [...filename]
```

## Examples

```
# Merge 3 files
deck file patch -o merged.yaml file1.yaml file2.yaml file3.yaml
```

## Flags

`--format`
:  Output format: yaml or json. (Default: `"yaml"`)

`-h`, `--help`
:  Help for merge.

`-o`, `--output-file`
:  Output file to write to. Use `-` to write to stdout. (Default: `"-"`).

## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


