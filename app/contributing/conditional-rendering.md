---
title: Conditional rendering
---

The Kong docs support conditional rendering based on the following:
* Product
* Product version


## Conditionally render content by product

If you have content that needs to be reused between multiple products, you can conditionally render parts of that 
for a specific product:

{% raw %}
```
This sentence is visible for every product that the content is used in.

{% unless page.edition == "konnect" %}
This will be hidden for Konnect.
{% endunless %}

{% if page.edition == "gateway" %}
This will show only for Kong Gateway.
{% endif %}
```
{% endraw %}

You can find all the supported editions in the [`app/_data/kong_versions.yml`](https://github.com/Kong/docs.konghq.com/blob/main/app/_data/kong_versions.yml) metadata file. 


## Conditionally render content by version

You can use conditional rendering by version for any content in the `app/_src` or `app/_hub` directories.

As we add new functionality, we want content on a page to be displayed only for specific releases of a product. 
You can use the `if_version` block for this, or `if_plugin_version` for any content in the Plugin Hub.

* `if_version` is used by {{site.base_gateway}}, {{site.mesh_product_name}}, {{site.kic_product_name}}, and decK documentation.
* `if_plugin_version` can only be used for plugin documentation in the `app/_hub` directory.

`if_version` and `if_plugin_version` support the following filters:
* `eq`: Render content that **equals** the provided version.
* `gte`: Render content that is **equal or greater than** the provided version.
* `lte`: Render content that is **equal or less than** the provided version.

For example, `eq` displays content for only one specific version:

{% raw %}

```

{% if_version eq:1.11.x %}
This will only show for version 1.11.x
{% endif_version %}

```

Or for a plugin:
```

{% if_plugin_version eq:2.8.x %}
This will only show for plugin version 2.8.x
{% endif_plugin_version %}

```
{% endraw %}

Greater than (`gte`) and less than (`lte`) are **inclusive** of the version provided:

{% raw %}
```

{% if_version gte:1.11.x %}
This will only show for version 1.11.x and later (1.12.x, 2.0.0 etc)
{% endif_version %}



{% if_plugin_version lte:2.8.x %}
This will only show for plugin version 2.8.x and earlier (2.7.x, 2.6.x etc)
{% endif_plugin_version %}


{% if_version gte:1.11.x lte:1.19.x %}
This will show for versions 1.11.x through 1.19.x, inclusive
{% endif_version %}
```
{% endraw %}

### Table rows

When working with tables, you can set a conditional filter for a given row. 
The filter expects new lines before and after `if_version` or `if_plugin_version`:

```
| Name  | One         | Two    |
|-------|-------------|--------|
| Test1 | Works       | Shows  |
{% raw %}

{% if_version gte: 1.11.x %}
| Test2 | Conditional | Hidden |
{% endif_version %}

{% endraw %}
| Test1 | Works       | Shows  |
```

The above will be rendered as a single table.

### Inline content

If you want to conditionally render content in a sentence, you can use `if_version` or `if_plugin_version`
and specify `inline:true`:

{% raw %}
```
Hello {% if_version eq:1.0.0 inline:true %}everyone in the {% endif_version %} world.

Hello {% if_plugin_version lte:2.8.x inline:true %}everyone in the {% endif_plugin_version %} world.
```
{% endraw %}

### Front matter

You may want to set values in a page's front matter conditionally. You can do this using `overrides`:

```yaml
---
title: Page Here
alpha: false # This is the default, but is here for completeness

overrides:
  alpha:
    true:
      gte: 2.3.x
      lte: 2.5.x
---
```

In the above example, versions `2.3.x`, `2.4.x` and `2.5.x` will have `alpha: true`, and all other versions will have `alpha: false`.

You can set the key to any scalar value. Here's an example using strings to switch something from "Private Beta" (2.8.x and earlier) to GA (anything later than this).

```yaml
---
title: Another Page
availability: GA

overrides:
  availability:
    Private Beta:
      lte: 2.8.x
---
```

### Plugin parameters

Generated parameters for files in the `app/_hub` directory can specify `minimum_version` and `maximum_version` fields.
Here's an example where `access_token_name` will only be shown for versions `1.4.0` to `1.7.0`, while `demo_field` will always be shown:

```yaml
params:
  name: sample-plugin
  service_id: true
  route_id: true
  consumer_id: false
  dbless_compatible: "yes"
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

You can do the same for plugin protocols:

```yaml
params:
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
    - name: ws
      minimum_version: "3.0.x"
    - name: wss
      minimum_version: "3.0.x"
```