---
title: Single-sourced plugins
---

We use a Jekyll plugin (`plugin_single_source_generator.rb`) to dynamically generate pages from a single source file. 

Here's how it works:

1. Read all version files (`app/_hub/**/versions.yml`).
1. For each version listed in the file, check if `app/_hub/[vendor]/[name]/[version].md` exists.
1. If not, read `app/_hub/[vendor]/[name]/_index.md` and generate a version of the page.
1. The latest version is always generated as `index.html`, while older versions are generated as `[version].html`.

## Automatic plugin versioning

Each `versions.yml` is expected to contain a `strategy` and a list of `releases`: 

```yaml
strategy: gateway
releases:
  minimum_version: '2.1.x'
  maximum_version: '3.0.x' # optional
```

Which reads all available Gateway versions from `kong_versions.yml` and selects those that are in the specified range.

{:.note}
> **Note**: Although `strategy` supports either `matrix` for the original rendering, or `gateway` for plugins that have versions pinned to the Gateway version, 
the `matrix` option is no longer in use. It remains at the moment for backwards compatibility.

This can also be used with `overrides` to set a custom plugin version name:

```yaml
strategy: gateway
releases:
  minimum_version: '2.1.x'
overrides:
  2.8.x: 0.13.x
  2.7.x: 0.12.x
```

## Open source and enterprise discrepancies

In some cases, the version of a plugin is different between the Community Edition (OSS) and Enterprise Edition. 
In these instances, each release should be entered as a unique version in the config file. 

Here's an example where Gateway 2.3.x CE uses plugin version 1.0, while 2.3.x EE uses plugin version 2.0:

```yaml
strategy: gateway
releases:
  minimum_version: 2.2.x
replacements:
  2.3.x:
    - 2.3.x-CE
    - 2.3.x-EE
overrides:
  2.4.x: 2.0.x
  2.3.x-EE: 2.0.x
  2.3.x-CE: 1.0.x
  2.2.x: 1.0.x
```

`2.3.x-EE` and `2.4.x` both use plugin version `2.0.x` and the default `_index` source file. `2.3.x-CE` and `2.2.x` use plugin version `1.0.x`.

If you want to use `releases` but have one or two versions that you need to override, you can use `replacements`:

```yaml
strategy: gateway
releases:
  minimum_version: '2.1.x'
replacements:
  2.3.x:
    - 2.3.x-CE
    - 2.3.x-EE
overrides:
  2.3.x-EE: 2.0.x
  2.3.x-CE: 1.0.x
```


## See also

* [Conditional rendering](/contributing/conditional-rendering/): Render content in a file based on version filters
* [Single-sourced versions](/contributing/single-sourced-versions/): Learn about how single sourcing is implemented for other Kong products
