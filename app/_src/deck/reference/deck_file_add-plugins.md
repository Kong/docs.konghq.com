---
title: deck file add-plugins
source_url: https://github.com/Kong/deck/tree/main/cmd/file_addplugins.go
content_type: reference
---

Add plugins to objects in a decK file.

The plugins are added to all objects that match the selector expressions. If no
selectors are given, the plugins are added to the top-level `plugins` array.

The plugin files have the following format (JSON or YAML) and are applied in the
order they are given:

    { "_format_version": "1.0",
      "add-plugins": [
        { "selectors": [
            "$..services[*]"
          ],
          "overwrite": false,
          "plugins": [
            { "name": "my-plugin",
              "config": {
                "my-property": "value"
              }
            }
           ]
        }
      ]
    }

## Syntax

```
deck file add-plugins [command-specific flags] [global flags] [...plugin-files]
```

## Examples

```
# adds 2 plugins to all services in a deck file, unless they are already present
cat kong.yml | deck file add-plugins --selector='services[*]' plugin1.json plugin2.yml

# same, but now overwriting plugins if they already exist
cat kong.yml | deck file add-plugins --overwrite --selector='services[*]' plugin1.json plugin2.yml
```

## Flags

`--config`
:  JSON snippet containing the plugin configuration to add. Repeat to add
multiple plugins.

`--format`
:  Output format: JSON or YAML. (Default: `"YAML"`)

`-h`, `--help`
:  Help for add-plugins.

`-o`, `--output-file`
:  Output file to write. Use `-` to write to stdout. (Default: `"-"`)

`--overwrite`
:  Specify this flag to overwrite plugins by the same name if they already
exist in an array. The default behavior is to skip existing plugins. (Default: `false`)

`--selector`
:  JSON path expression to select plugin-owning objects to add plugins to.
Defaults to the top level (selector `$`). Repeat for multiple selectors.

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
