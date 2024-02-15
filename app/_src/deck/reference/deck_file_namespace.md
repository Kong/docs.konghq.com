---
title: deck file namespace
source_url: https://github.com/Kong/deck/tree/main/cmd/file_namespace.go
content_type: reference
---

Apply a namespace to routes in a decK file by prefixing the path.

By prefixing paths with a specific segment, colliding paths to services can be
namespaced to prevent collisions. For example, two API definitions that both expose a
`/list` path. By prefixing one with `/addressbook` and the other with `/cookbook`,
the resulting paths `/addressbook/list` and `/cookbook/list` can be exposed without
colliding.

To remove the prefix from the path before the request is routed to the service, the
following approaches are used:
- If the route has `strip_path=true`, then the added prefix will already be stripped.
- If the related service has a `path` property that matches the prefix, then the
  `service.path` property is updated to remove the prefix.
- A `pre-function` plugin will be added to remove the prefix from the path.

## Syntax

```sh
deck file namespace [command-specific flags] [global flags] filename [...filename]
```

## Examples

```sh
# Apply namespace to a decK file
cat kong.yml | deck file namespace --path-prefix=/kong
```

## Flags

`--format`
: Output format: yaml or json. (Default: `"yaml"`)

`-h`, `--help`
:  Help for patch.

`--output-file, -o`
: Output file to write. Use - to write to stdout. (Default: `"-"`)

`--selector`
: JSON pointer identifying an element to patch. Repeat for multiple selectors. Defaults to selecting all routes.

`--state, -s`
: DecK spec file to process. Use `-` to read from stdin. (Default: `"-"`)

`--path-prefix, -p`
: The path-based namespace to apply.

`--allow-empty-selectors`
: Do not error out if the selectors return empty.

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


