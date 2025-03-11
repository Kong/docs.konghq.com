---
title: Environment Variables
content_type: reference
---

decK can read environment variables at runtime, allowing you to pass per-environment configuration.

To allow decK to read environment variables, reference them as
`{%raw%}${{ env "DECK_*" }}{%endraw%}` in your state file.

The following example configures a Vault token using a decK environment variable:

```yaml
_format_version: "3.0"
vaults:
- name: hcv
  description: My custom HashiCorp Vault
  prefix: my-hcv
  config:
    host: "localhost"
    kv: "v2"
    mount: "secret"
    port: 8200
    protocol: "https"
    token: {%raw%}${{ env "DECK_HCV_TOKEN" }}{%endraw%}
```

To test, set the `DECK_HCV_TOKEN` environment variable and run `deck gateway sync`:

```bash
export DECK_HCV_TOKEN="TOKEN_GOES_HERE"
deck gateway sync kong.yaml
```