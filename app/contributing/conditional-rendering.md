---
title: Conditional rendering
---

## Conditionally render content by version

As we add new functionality, we'll want content on a page to be displayed for specific releases of a product. You can use the `if_version` block in a file for this:

{% raw %}
```

{% if_version eq:1.11.x %}
This will only show for version 1.11.x
{% endif_version %}
```
{% endraw %}

We also support greater than (`gte`) and less than (`lte`). This filter is **inclusive** of the version provided:

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

When working with tables, the filter expects new lines before and after `if_version`:

{% raw %}
```
| Name  | One         | Two    |
|-------|-------------|--------|
| Test1 | Works       | Shows  |

{% if_version gte: 1.11.x %}
| Test2 | Conditional | Hidden |
{% endif_version %}

| Test1 | Works       | Shows  |
```
{% endraw %}

The above will be rendered as a single table.

If you want to conditionally render content in a sentence, you can use `if_version` and specify `inline:true`:

{% raw %}
```
Hello {% if_version eq:1.0.0 inline:true %}everyone in the {% endif_version %} world.
```
{% endraw %}

## Conditionally render content by version

You can conditionally render content that only relates to a specific product:

{% raw %}
```
{% unless page.edition == "konnect" %}
This will be hidden for Konnect
{% endunless %}
```
{% endraw %}

## Conditionally render front matter

You may want to set values in the front matter conditionally. You can do this using `overrides`:

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