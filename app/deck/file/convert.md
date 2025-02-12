---
title: Convert
---

The convert command changes configuration files from one format into another compatible format. For example, a configuration for `kong-gateway-2.x` can be converted into a `kong-gateway-3.x` configuration file.

```bash
deck file convert --input-file kong2x.yaml --from kong-gateway-2.x --to kong-gateway-3.x
```

## Applied transformations

* `kong-gateway-2.x` to `kong-gateway-3.x`
  * Prefix any paths that look like a regular expression with a `~`
  * Generate default values for missing `namespace` fields in any Rate Limiting Advanced plugins