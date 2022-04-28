# Single Sourced Plugins

We use a Jekyll plugin (`plugin_single_source_generator.rb`) to dynamically generate pages from a single source file. It works as follows:

- Read all version files (`app/_hub/**/versions.yml`)
- For each version listed in the file, check if `app/_hub/[vendor]/[name]/[version].md` exists
- If not, read `app/_hub/[vendor]/[name]/_index.md` and generate a version of the page
- The latest version is always generated as `index.html`, while older versions are generated as `[version].html`

## Plugin Versions

Each `versions.yml` is expected to contain a `strategy` (either `matrix` for the original rendering, or `gateway` for plugins that have versions pinned to the Gateway version) and a list of `releases` like so:

```yaml
strategy: gateway
releases:
  - 3.0.x
  - 2.8.x
  - 2.7.x
```

If the gateway release does not match the plugin release, you can set an override for that version. Here's an example that sets explicit plugin values for 2.7 and 2.8:

```yaml
strategy: gateway
releases:
  - 3.0.x
  - 2.8.x
  - 2.7.x
overrides:
  2.8.x: 0.13.x
  2.7.x: 0.12.x
```

This would result in the following:

| Release | Plugin Version |
|---------|----------------|
| 3.0.x   | 3.0.x          |
| 2.8.x   | 0.13.x         |
| 2.7.x   | 0.12.x         |

### Automatic Plugin Versioning

If you do not want to specify every Gateway release using `releases`, you can set `delegate_releases: true` which will read all available Gateway versions from `kong_versions.yml`:

```yaml
strategy: gateway
delegate_releases: true
```

This can also be used with `overrides`:

```yaml
strategy: gateway
delegate_releases: true
overrides:
  2.8.x: 0.13.x
  2.7.x: 0.12.x
```

### CE/EE Discrepancies

In some cases, the version of a plugin is different between the Community Edition (OSS) and Enterprise Edition. In these instances, each release should be entered as a unique version in the config file. Here's an example where Gateway 2.3.x CE uses plugin version 1.0, whilst 2.3.x EE uses plugin version 2.0:

```yaml
strategy: gateway
releases:
  - 2.4.x
  - 2.3.x-CE
  - 2.3.x-EE
  - 2.2.x
sources:
  2.2.x-CE: _1.0
  2.2.x: _1.0
overrides:
  2.4.x: 2.0.x
  2.3.x-EE: 2.0.x
  2.3.x-CE: 1.0.x
  2.2.x: 1.0.x
```

`2.3.x-EE` and `2.4.x` both use plugin version `2.0.x` and the default `_index` source file. `2.3.x-CE` and `2.2.x` use plugin version `1.0.x` and the `_1.0` source file.

If you want to use `delegate_releases` but have one or two versions that you need to override, you can use `replacements` like so:

```yaml
strategy: gateway
delegate_releases: true
replacements:
  2.3.x:
    - 2.3.x-CE
    - 2.3.x-EE
sources:
  2.3.x-CE: _foo
overrides:
  2.3.x-EE: 2.0.x
  2.3.x-CE: 1.0.x
```

## Conditional Rendering

As we add new functionality, we'll want content to be displayed for specific versions of a plugin. We can use the `if_plugin_version` block for this:

```
{% if_plugin_version eq:1.11.x %}
This will only show for version 1.11.x
{% endif_plugin_version %}
```

We also support greater than (`gte`) and less than (`lte`). This filter is **inclusive** of the version provided:

```
{% if_plugin_version gte:1.11.x %}
This will only show for version 1.11.x and above (1.12.x, 2.0.0 etc)
{% endif_plugin_version %}

{% if_plugin_version lte:1.11.x %}
This will only show for version 1.11.x and below (1.10.x, 1.0.0 etc)
{% endif_plugin_version %}

{% if_plugin_version gte:1.11.x lte:1.19.x %}
This will show for versions 1.11.x to 1.19.x inclusive
{% endif_plugin_version %}
```

When working with tables, the filter expects new lines before and after `if_plugin_version` e.g.:

```
| Name  | One         | Two    |
|-------|-------------|--------|
| Test1 | Works       | Shows  |

{% if_plugin_version gte: 1.11.x %}
| Test2 | Conditional | Hidden |
{% endif_plugin_version %}

| Test1 | Works       | Shows  |
```

The above will be rendered as a single table

## Params

Generated parameters can specify `minimum_version` and `maximum_version` fields. Here's an example where `access_token_name` will only be shown for versions `1.4.0` to `1.7.0`, while `demo_field` will always be shown:

```yaml
params:
  name: sample-plugin
  service_id: true
  route_id: true
  consumer_id: false
  dbless_compatible: "yes"
  manager_examples: false
  konnect_examples: false
  config:
    - name: demo_field
      required: true
      default: "`access_token`"
      datatype: string
      description: This is a demo_field
    - name: access_token_name
      required: true
      default: "`access_token`"
      datatype: array of string elements
      description: This is a description
      minimum_version: "1.4.0"
      maximum_version: "1.7.0"
```

Both `minimum_version` and `maximum_version` are optional.
