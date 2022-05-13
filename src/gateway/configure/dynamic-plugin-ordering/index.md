---
title: Dynamic Plugin Ordering
badge: enterprise
content_type: explanation
---

The order in which plugins are executed in Kong is determined by their
`static priority`. As the name suggests, this value is _static_ and can't be
 easily changed by the user.

You can override the priority for any Kong plugin using each plugin's
`ordering` field. This determines plugin ordering during the `access` phase,
and lets you create _dynamic_ dependencies between plugins.

## Concepts

### Dependency Tokens

Use one of the following tokens to describe a dependency to a plugin:

* `before`
	 The plugin will be executed _before_ a specified plugin or list of plugins.

* `after`
	 The plugin will be executed _after_ a specified plugin or list of plugins.

### Phases

When a request is proccessed by Kong it will go through various phases, depending on the configured plugins. You can influence the order in which plugins are executed for each phase.

Currently Kong supports only the `access` phase.

### API

To express dependencies for plugins within a certain request phase you may use the following interface.


```yaml
ordering:
  $dependency_token:
    $supported_phase:
      - pluginA
      - ...
```

When you'd like to express that PluginA's _access_ phase should run _before_ PluginB's _access_ phase you would write something like this. (Examples are in deck-style yaml format)

```yaml
PluginA:
  ordering:
    before:
      access:
        - PluginB
```

## Known Limitations

### Consumer Scoping

It is not supported to apply a new order to plugins that are consumer-scoped. As the order of the plugins must be determined after the consumer mapping has happened (which happens in the acceess phase) we can't reliably change the order to plugins.

### Cascading Deletes & Updates

Currently there is no support to detect if a plugin that has a dependency to another plugin was deleted or not so handle your configuration with care.

### Performance Implications

Dynamic Plugin Ordering requires to sort plugins during the a request. This adds natrually adds latency to a request. In some cases this might be compensated for when you run rate-limiting before an expensive authentication plugin.

### Workspaces

Re-ordering _any_ plugin in a workspace has performance implications to all other plugins withing this workspace. If you can, consider offloading this to a separate workspace.

### Validation

Validation is a on-trivial task to do as it would require insight in the user's business logic.
Kong tries to catch basic mistakes but can't detect all potentially dangerous configurations. Please handle this feature with care!
