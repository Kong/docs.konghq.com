---
title: Dynamic Plugin Ordering
badge: enterprise
content_type: explanation
---

The order in which plugins are executed in {{site.base_gateway}} is determined by their
`static priority`. As the name suggests, this value is _static_ and can't be
 easily changed by the user.

You can override the priority for any {{site.base_gateway}} plugin using each plugin's
`ordering` field. This determines plugin ordering during the `access` phase,
and lets you create _dynamic_ dependencies between plugins.

## Concepts

### Dependency tokens

Use one of the following tokens to describe a dependency to a plugin:

* `before`: The plugin will be executed _before_ a specified plugin or list of plugins.
* `after`: The plugin will be executed _after_ a specified plugin or list of plugins.

### Phases

When a request is processed by {{site.base_gateway}}, it goes through various
[phases](/gateway/latest/plugin-development/custom-logic/#available-contexts),
depending on the configured plugins. You can influence the order in which
plugins are executed for each phase.

Currently, {{site.base_gateway}} supports dynamic plugin ordering in the
`access` phase.

### API

You can use the following API to express dependencies for plugins within a
certain request phase (examples are in decK-formatted YAML):

```yaml
ordering:
  $dependency_token:
    $supported_phase:
      - pluginA
      - ...
```

For example, if you want to express that PluginA's `access` phase should
run _before_ PluginB's `access` phase, you would write something like this:

```yaml
PluginA:
  ordering:
    before:
      access:
        - PluginB
```

## Known limitations

### Consumer scoping

Consumer-scoped plugins don't support dynamic ordering because consumer mapping
also runs in the access phase. The order of the plugins must be determined
after consumer mapping has happened. {{site.base_gateway}} can't reliably
change the order of the plugins in relation to consumer mapping.

### Cascading deletes & updates

There is no support to detect if a plugin has a dependency to
a deleted plugin, so handle your configuration with care.

### Performance implications

Dynamic plugin ordering requires sorting plugins during a request. This naturally
adds latency to the request. In some cases, this might be compensated for when
you run rate limiting before an expensive authentication plugin.

Re-ordering _any_ plugin in a workspace has performance implications to all
other plugins within the same workspace. If possible, consider offloading plugin
ordering to a separate workspace.

### Validation

Validating dynamic plugin ordering is a non-trivial task and would require
insight into the user's business logic. {{site.base_gateway}} tries to catch
basic mistakes but it can't detect all potentially dangerous configurations.

If using dynamic ordering, manually test all configurations, and handle this
feature with care.

{% if_version lte:3.0.x %}
### Kong Manager

Kong Manager doesn't support dynamic plugin ordering configuration through the
UI. Use the Kong Admin API or a declarative configuration file to set
plugin ordering.
{% endif_version %}

{% if_version gte:3.1.x %}
### Kong Manager

Kong Manager also supports dynamic plugin ordering configuration through the
UI. For more information, see [Get Started with Dynamic Plugin Ordering](/gateway/{{page.release}}/kong-enterprise/plugin-ordering/get-started/)
{% endif_version %}

## See also

Check out the examples in the
[getting started guide for dynamic plugin ordering](/gateway/{{page.release}}/kong-enterprise/plugin-ordering/get-started).
