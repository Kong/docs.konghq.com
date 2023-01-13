---
title: Single-sourced versions
---

Historically, we have supported multiple versions of a product by copying the previous release folder and renaming it in the `app` folder. This served us well with a small number of versions, but has not scaled well as we approach 50 versions of our products.

We now use a Jekyll plugin (`single_source_generator.rb`) to dynamically generate pages from a single source file:

- Read all navigation files (`app/_data/docs_nav_*.yml`).
- If the file does not contain `generate: true` at the top level, skip it.
- If it does, loop through all items in the navigation:
  - If `assume_generated` is not set at the top level, or it is set to `true`, then all items will be generated.
  - If `assume_generated` is set to `false`, then each item in the navigation that should be generated will need `generate: true` to be set.
- Each file that should be generated goes through the following process:
  - Build the base directory. This will be `app/_src/<product>` by default, but if the `src` starts with a `/`, it will be treated as a full path in `app/_src/`. For example, `/shared/license` would be `app/_src/shared/license` while `shared/license` would be `app/_src/<product>/shared/license`.
  - If `src` is set on the item, we'll use that as the source file.
  - If `src` is _not_ set on the item:
    - If `absolute_url` is set, skip the item. We assume it's generated another way (unless the `url` is equal to `/<product>/`, which is a special case and is always generated).
    - Else, use the `url` and set `src` to be `url`.
  - Read `app/_src/<product>/<src>.md` or `app/_src/<product>/<src>/index.md` and generate a file at `<product>/<version>/<url>` using that content.

## Single source an entire product

Setting `generate: true` at the top level of a nav file will use the generator for every path in the file.

The comments in the following example file describe what will be read, and what URL will be generated:

{% raw %}
```yaml
product: deck
release: 1.11.x
generate: true
items:
  - title: Introduction
    # Reads `src/deck/index.md` and writes `/deck/<release>/index.html`
    # This is a special case because absolute_url is true, but `/deck/` is equal to `/<product>/`
    # and we must always generate an index page
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
{% endraw %}

## Single source specific files

You may not want to update an entire release at once. In this instance, single sourcing specific files might be useful. You can set `assume_generated: false` at the top level, then use `generate: true` on individual items to enable this.

{% raw %}
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
{% endraw %}

## Manage multiple releases and single sourcing

If a page requires a major rewrite for a release, it doesn't make sense to keep everything in a single file. In this instance, we should append the major version to the filename (for example, `instructions-v3.md`) and use the `src` parameter to point to a specific file:

{% raw %}
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
        # This is how you can have multiple releases of a single source file when completely rewriting content
        url: /terminology
        src: terminology-v3
```
{% endraw %}

## Render unlisted pages

In some cases, you may want to render a page within a version without adding it to the side navigation. You can do this by adding an `unlisted` section to the data file:

{% raw %}
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
unlisted:
  # Read from src/deck/how-to/example.md. Rendered at /deck/how-to/example/
  # Not listed in the sidebar
  # Options such as 'generate' and 'src' are valid here too
  - url: /how-to/example
```
{% endraw %}