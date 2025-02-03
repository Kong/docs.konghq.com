---
title: Render
---

Combines multiple complete configuration files and renders them as one Kong declarative config file.

This command renders a full declarative configuration in JSON or YAML format by assembling multiple files and populating defaults and environment substitutions. This command is useful to observe what configuration would be sent prior to synchronizing to the gateway.

In comparison to the `deck file merge` command, the render command accepts complete configuration files, while `deck file merge` can operate on partial files.

For example, the following command takes two input files and renders them as one combined JSON file:

```bash
deck file render kong1.yml kong2.yml
```

The `deck file render` validates the configuration against a schema, and warns if any duplicate entities are detected.