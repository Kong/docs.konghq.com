# Single Sourced Plugins

We use a Jekyll plugin (`plugin_single_source_generator.rb`) to dynamically generate pages from a single source file. It works as follows:

- Read all navigation files (`app/_data/extensions/**/*.yml`)
- For each version listed in the file, check if `app/_hub/[vendor]/[name]/[version].md` exists
- If not, read `app/_hub/[vendor]/[name]/_index.md` and generate a version of the page
- The latest version is always generated as `index.html`, whilst older versions are generated as `[version].html`

## Concepts

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

Generated parameters can specify `minimum_version` and `maximum_version` fields. Here's an example where `access_token_name` will only be shown for versions `1.4.0` to `1.7.0`, whilst `demo_field` will always be shown

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

Both `minimum_version` and `maximum_version` are optional
