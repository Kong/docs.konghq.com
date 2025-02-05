---
title: Managing Sensitive Data
content_type: reference
---

Hardcoding sensitive information in your declarative configuration files is not recommended. decK provides two options to avoid this anti-pattern:

1. Configure and use [vaults](/gateway/latest/kong-enterprise/secrets-management/) with {{ site.base_gateway }}.
1. Read environment variables when running decK commands.

## Configuring Kong vaults

decK provides full support for managing {{ site.base_gateway }} vaults declaratively.

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
    token: "PUT_YOUR_TOKEN_HERE"
```

When managing vaults with declarative configuration, you need to take certain precautions. For larger teams with many contributors, or organizations with multiple teams, we recommend splitting vault configuration and managing it separately.

### Why split out vault configuration?

* Vault are closer to infrastructure than other {{site.base_gateway}} configurations.  Separation of routing policies from infrastructure-specific configurations helps keep configuration organized.
* Vaults may be shared across teams. In this case, one specific team shouldn't control the vault's configuration. One team changing the vault can have disastrous impact on another team.
* If a vault is deleted while in use -- that is, if there are still references to secrets in a vault in configuration -- it can lead to total loss of proxy capabilities. Those secrets would be unrecoverable.

### How should I manage my vault configuration with decK?

To keep your environment secure and avoid taking down your proxies by accident, make sure to:

* Manage vaults with distributed configuration via tags.
* Use a separate [RBAC role, user, and token](/deck/manage-gateway/rbac/)
to manage vaults. Don't use a generic admin user.
* Set up a separate CI pipeline for vaults.

## Manage vaults with distributed configuration

Avoid mixing vault configuration with other {{site.base_gateway}} entities. Instead, manage vaults with [distributed configuration](/deck/manage-gateway/tags/#select-tags) via `select_tags`.

```yaml
_format_version: "3.0"
_info:
  select_tags:
    - sensitive-vaults
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
    token: "PUT_YOUR_TOKEN_HERE"
```

## Using decK environment variables

In the example above, the token used to unseal the HashiCorp Vault is stored in plain text in the declarative configuration file.

decK can read environment variables at runtime, allowing you to pass sensitive information when the `sync` is being executed.

{:.important}
> The token will still be visible in plain text to anyone that can read the `/vaults` entity on the Admin API.

To allow decK to read environment variables, reference them as
`{%raw%}${{ env "DECK_*" }}{%endraw%}` in your state file.

The following example updates the Vault configuration above to use a decK environment variable:

```yaml
_format_version: "3.0"
_info:
  select_tags:
    - sensitive-vaults
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