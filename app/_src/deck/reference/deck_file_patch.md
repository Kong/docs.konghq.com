---
title: deck file patch
source_url: https://github.com/Kong/deck/tree/main/cmd/file/patch.go
content_type: reference
---

Apply patches on top of a decK file.

The input file is read, the patches are applied, and if successful, written
to the output file. The patches can be specified by a `--selector` and one or more
`--value` tags, or via patch files.

When using `--selector` and `--values`, the items are selected by the `selector`, 
which is a JSONPath query. From the array of nodes found, only the objects are updated.
The `values` are applied on each of the JSONObjects returned by the `selector`.

The value must be a valid JSON snippet, so use single/double quotes
appropriately. If the value is empty, the field is removed from the object.

Examples of valid values:

```sh
# set field "read_timeout" to a numeric value of 10000
--selector="$..services[*]" --value="read_timeout:10000"

# set field "_comment" to a string value
--selector="$..services[*]" --value='_comment:"comment injected by patching"'

# set field "_ignore" to an array of strings
--selector="$..services[*]" --value='_ignore:["ignore1","ignore2"]'

# remove fields "_ignore" and "_comment" from the object
--selector="$..services[*]" --value='_ignore:' --value='_comment:'

# append entries to the methods array of all route objects
--selector="$..routes[*].methods" --value='["OPTIONS"]'
```

Patch files have the following format (JSON or YAML) and can contain multiple
patches that are applied in order:

```json
{ "_format_version": "1.0",
  "patches": [
    { "selectors": [
        "$..services[*]"
      ],
      "values": {
        "read_timeout": 10000,
        "_comment": "comment injected by patching"
      },
      "remove": [ "_ignore" ]
    }
  ]
}
```

If the `values` object instead is an array, then any arrays returned by the selectors
will get the `values` appended to them.

## Syntax

```
deck file patch [command-specific flags] [global flags] [...patch-files]
```

## Examples

```
# update the read-timeout on all services
cat kong.yml | deck file patch --selector="$..services[*]" --value="read_timeout:10000"
```

## Flags

`--format`
:  Output format: yaml or json. (Default: `"yaml"`)

`-h`, `--help`
:  Help for patch.

`-o`, `--output-file`
:  Output file to write to. Use `-` to write to stdout. (Default: `"-"`)

`--selector`
:  json-pointer identifying the element to patch. Repeat for multiple selectors.

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

`--value`
:  A value to set in the selected entry in `<key:value>` format. Can be specified multiple times.


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


