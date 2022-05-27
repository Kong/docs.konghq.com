# Single Sourced Versions

## History

Historically, we have supported multiple versions of a product by copying the previous release folder and renaming it within the `app` folder. This served us well with a small number of versions, but has not scaled well as we approach 50 versions of our products.

We now use a Jekyll plugin (`single_source_generator.rb`) to dynamically generate pages from a single source file. It works as follows:

- Read all navigation files (`app/_data/docs_nav_*.yml`)
- If the file does not contain `generate: true` at the top level, skip it
- If it does, loop through all items in the navigation
  - If `assume_generated` is not set at the top level, or it is set to `true` then all items will be generated (unless `generate: false` is explicitly set on an item)
  - If `assume_generated` is set to `false` then each item in the navigation that should be generated will need `generate: true` to be set
- Each file that should be generated goes through the following process:
  - Build up the base directory: `src/<product>` by default, but if the `src` starts with a `/` it will be treated as a full path within `src`. e.g. `/shared/license` would be `/src/shared/license` whilst `shared/license` would be `/src/<product>/shared/license`
  - If `src` is set on the item, we'll use that as the source file
  - If `src` is _not_ set on the item:
    - If `absolute_url` is set, skip the item. We assume it's generated another way (unless the `url` is equal to `/<product>/`, which is a special case and is always generated)
    - Else use the `url` and set `src` to be `url`
  - Read `src/<product>/<src>.md` or `src/<product>/<src>/index.md` and generate a file at `<product>/<version>/<url>` using that content

## Concepts

### Concept 1: Single source an entire product

Setting `generate: true` at the top level will use the generator for every path in the file.

I've added comments to the file to show what will be read, and what URL will be generated:

```yaml
product: deck
release: 1.11.x
generate: true
items:
  - title: Introduction
    # Reads `src/deck/index.md` and writes `/deck/<release>/index.html`
    # This is a special case as absolute_url is true, but `/deck/` is equal to `/<product>/`
    # and we always need to generate an index page
    url: /deck/
    absolute_url: true
    items:
      - text: Terminology
        # Reads `src/deck/terminology.md` and writes `/deck/<release>/terminology/index.html`
        url: /terminology
      - text: Architecture
        # Reads `src/deck/design-architecture.md` and writes `/deck/<release>/design-architecture/index.html`
        url: /design-architecture

  - title: Changelog
    icon: /assets/images/icons/documentation/icn-references-color.svg
    # Does not read any file as absolute_url is set to true
    url: https://github.com/kong/deck/blob/main/CHANGELOG.md
    absolute_url: true

  - title: Installation
    icon: /assets/images/icons/documentation/icn-deployment-color.svg
    url: /installation
    # Reads `src/deck/installation-guide.md` and writes `/deck/<release>/installation/index.html`
    src: installation-guide
```

### Concept 2: Single source specific files

You may not want to update an entire release at once. In this instance, single sourcing specific files might be useful. You can set `assume_generated: false` at the top level, then use `generate: true` on individual items to enable this.

```yaml
product: deck
release: 1.11.x
generate: true
# This line will make Jekyll read `app/<product>/<release>/<file>.md` by default
# unless `generate: true` is set on a specific item
assume_generated: false
items:
  - title: Introduction
    # Reads `app/deck/1.11.x/index.md` like normal
    url: /deck/
    absolute_url: true
    items:
      - text: Terminology
        # Reads `app/deck/1.11.x/terminology.md` like normal
        url: /terminology
      - text: Architecture
        # Reads `src/deck/design-architecture.md` and writes `/deck/<release>/design-architecture/index.html`
        url: /design-architecture
        generate: true

  - title: Installation
    icon: /assets/images/icons/documentation/icn-deployment-color.svg
    url: /installation
    # Reads `src/deck/installation-v3.md` and writes `/deck/<release>/installation/index.html`
    src: installation-v3
    generate: true
```

### Concept 3: Multiple releases + Single Sourcing

We may rewrite entire pages over time, and it doesn't make sense to keep everything in a single file. In this instance, we should append the major version to the filename e.g. `instructions-v3.md` and use the `src` parameter to point at a specific file:

```yaml
product: deck
release: 1.11.x
generate: true
items:
  - title: Introduction
    url: /deck/
    absolute_url: true
    items:
      - text: Terminology
        # Reads `src/deck/terminology-v3.md` and writes `/deck/<release>/terminology/index.html`
        # This is how you can have multiple release of a single source file when completely rewriting content
        url: /terminology
        src: terminology-v3
```

## Conditional Rendering

As we add new functionality, we'll want content to be displayed for specific releases of a product. We can use the `if_version` block for this:

```
{% if_version eq:1.11.x %}
This will only show for version 1.11.x
{% endif_version %}
```

We also support greater than (`gte`) and less than (`lte`). This filter is **inclusive** of the version provided:

```
{% if_version gte:1.11.x %}
This will only show for version 1.11.x and above (1.12.x, 2.0.0 etc)
{% endif_version %}

{% if_version lte:1.11.x %}
This will only show for version 1.11.x and below (1.10.x, 1.0.0 etc)
{% endif_version %}

{% if_version gte:1.11.x lte:1.19.x %}
This will show for versions 1.11.x to 1.19.x inclusive
{% endif_version %}
```

When working with tables, the filter expects new lines before and after `if_version` e.g.:

```
| Name  | One         | Two    |
|-------|-------------|--------|
| Test1 | Works       | Shows  |

{% if_version gte: 1.11.x %}
| Test2 | Conditional | Hidden |
{% endif_version %}

| Test1 | Works       | Shows  |
```

The above will be rendered as a single table