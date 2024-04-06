---
title: deck file namespace
source_url: https://github.com/Kong/deck/tree/main/cmd/file_namespace.go
content_type: reference
---

{% if_version gte:1.36.x}

Apply a namespace to routes in a decK file by path or hostname.

There are two main ways to namespace APIs:

1. Use path prefixes, all on the same hostname;
   a. `http://api.acme.com/service1/somepath`
   b. `http://api.acme.com/service2/somepath`
2. Use separate hostnames:
   a. `http://service1.api.acme.com/somepath`
   b. `http://service2.api.acme.com/somepath`

For hostnames, the `--host` and `--clear-hosts` flags are used. Just using `--host` appends
to the existing hosts, while adding `--clear-hosts` will effectively replace the existing ones.
For path prefixes, the `--path-prefix` flag is used. Combining them is possible.

**Note on path-prefixing**: To remain transparent to the backend services, the added path
prefix must be removed from the path before the request is routed to the service.
To remove the prefix, the following approaches are used (in order):
1. If the route has `strip_path=true`, then the added prefix will already be stripped.
2. If the related service has a `path` property that matches the prefix, then the
  `service.path` property is updated to remove the prefix.
3. A `pre-function` plugin will be added to remove the prefix from the path.

{% endif_version %}

{% if_version lte:1.35.x %}
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

{% endif_version %}

## Syntax

```sh
deck file namespace [command-specific flags] [global flags] filename [...filename]
```

## Examples

```sh
# Apply namespace to a deckfile, path and host:
deck file namespace --path-prefix=/kong --host=konghq.com --state=deckfile.yaml

# Apply namespace to a deckfile, and write to a new file
# Example file 'kong.yaml':
routes:
- paths:
  - ~/tracks/system$
  strip_path: true
- paths:
  - ~/list$
  strip_path: false

# Apply namespace to the deckfile, and write to stdout:
cat kong.yaml | deck file namespace --path-prefix=/kong

# Output:
routes:
- paths:
  - ~/kong/tracks/system$
  strip_path: true
  hosts:
  - konghq.com
- paths:
  - ~/kong/list$
  strip_path: false
  hosts:
  - konghq.com
  plugins:
  - name: pre-function
    config:
      access:
      - "local ns='/kong' -- this strips the '/kong' namespace from the path\nlocal <more code here>"

```
{% endif_version %}
{% if_version lte:1.35.x %}

```sh
# Apply namespace to a decK file
cat kong.yml | deck file namespace --path-prefix=/kong
```
{% endif_version %}

## Flags

`--allow-empty-selectors`
:  Do not error out if the selectors return empty (Default: `false`)

{% if_version gte:1.36.x %}
`-c`, `--clear-hosts`
:  Clear existing hosts. (Default: `false`)
{% endif_version %}

`--format`
: Output format: yaml or json. (Default: `"yaml"`)

`-h`, `--help`
:  Help for patch.

{% if_version gte:1.36.x %}
`--host`
:  Hostname to add for host-based namespacing. Repeat for multiple hosts.
{% endif_version %}

`--output-file, -o`
: Output file to write. Use - to write to stdout. (Default: `"-"`)

`--path-prefix, -p`
: The path-based namespace to apply.

`--selector`
: JSON pointer identifying an element to patch. Repeat for multiple selectors. Defaults to selecting all routes.

`--state, -s`
: DecK spec file to process. Use `-` to read from stdin. (Default: `"-"`)


## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


