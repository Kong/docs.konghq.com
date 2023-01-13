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

As we add new functionality, we want content on a page to be displayed only for specific releases of a product. You can use the `if_version` block for this.

`if_version` supports the following filters:
* `eq`: Render content that **equals** the provided version.
* `gte`: Render content that is **equal or greater than** the provided version.
* `lte`: Render content that is **equal or less than** the provided version.

`eq` displays content for only one specific version:

{% raw %}
```

{% if_version eq:1.11.x %}
This will only show for version 1.11.x
{% endif_version %}
```
{% endraw %}

Greater than (`gte`) and less than (`lte`) are **inclusive** of the version provided:

{% raw %}
```

{% if_version gte:1.11.x %}
This will only show for version 1.11.x and later (1.12.x, 2.0.0 etc)
{% endif_version %}

{% if_version lte:1.11.x %}
This will only show for version 1.11.x and earlier (1.10.x, 1.0.0 etc)
{% endif_version %}

{% if_version gte:1.11.x lte:1.19.x %}
This will show for versions 1.11.x through 1.19.x, inclusive
{% endif_version %}
```
{% endraw %}

### Table rows

When working with tables, you can set a conditional filter for a given row. 
The filter expects new lines before and after `if_version`:

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

If you want to conditionally render content in a sentence, you can use `if_version` and specify `inline:true`:

{% raw %}
```
Hello {% if_version eq:1.0.0 inline:true %}everyone in the {% endif_version %} world.
```
{% endraw %}

### Front matter

You may want to set values in a page's front matter conditionally. You can do this using `overrides`:

{% raw %}
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
{% endraw %}

In the above example, versions `2.3.x`, `2.4.x` and `2.5.x` will have `alpha: true`, and all other versions will have `alpha: false`.

You can set the key to any scalar value. Here's an example using strings to switch something from "Private Beta" (2.8.x and earlier) to GA (anything later than this).

{% raw %}
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
{% endraw %}