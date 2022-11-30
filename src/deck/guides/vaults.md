---
title: Secret Management with decK
content_type: how-to
---

decK supports secret references for encoded values in {{site.base_gateway}}.
You can store your secrets in a [vault backend](/gateway/latest/kong-enterprise/secrets-management/),
then reference them in your declarative configuration files.

You can use secrets to store sensitive data, such as credentials.

See [Secrets Management in {{site.base_gateway}}](/gateway/latest/kong-enterprise/secrets-management/#what-can-be-stored-as-a-secret)
for a full list of values that can be stored as secrets.

{:.note}
> For storing configuration values as environment variables on the node running decK,
see [Using Environment Variables with decK](/deck/latest/guides/environment-variables/).
The reference format for secrets is _not_ the same as references for environment
variables used by decK.

## Configure a secret vault

Set up a secret vault using the {{site.base_gateway}} `vaults` entity.

For example, add the following snippet to your
declarative configuration file (`kong.yaml` by default) to set up a vault using
environment variables as the backend, configure a prefix for the vault, and a
prefix for the reference:

```yaml
_format_version: "3.0"
vaults:
- config:
    prefix: MY_SECRET_
  description: ENV vault for secrets
  name: env
  prefix: my-env-vault
```

Key | Description
----|---
`vaults.config` | Stores the configuration for a particular vault. The configuration values required depend on the vault that you are using. In this example, the `vaults.config.prefix` value configures the prefix for the environment variable that the value will be stored in. See the individual [vault backends](/gateway/latest/kong-enterprise/secrets-management/backends/) to find the required configuration values for your particular vault type.
`vaults.description` | An optional description for your vault.
`vaults.name` | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`.
`vaults.prefix` | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://my-env-vault/<some-secret>}`.

{{site.base_gateway}} also supports HashiCorp Vault, GCP, and AWS as [vault backends](/gateway/latest/kong-enterprise/secrets-management/backends/).

{:.important}
> **Important**: Manage your vault configuration separately from other {{site.base_gateway}}
entities. See [Best Practices](#best-practices) in this topic for more information.

## Store and reference secrets

Store your sensitive values as secrets on the node running the {{site.base_gateway}} instance:

```sh
export MY_SECRET_CERT="<cert data>" \
export MY_SECRET_KEY="<key data>"
```

Now you can reference the secret in subsequent configurations:

```yaml
certificates:
- id: B0DBE8FD-E5E6-414A-A0DC-0160665620AB
  cert: "{vault://my-env-vault/cert}"
  key: "{vault://my-env-vault/key}"
```

{:.important}
> **Important**: If a vault reference changes, it can cause {{site.base_gateway}} to not function correctly.
If changing references, make sure to update both the vault configuration and all places
that the reference is used in.

## Best practices

When managing vaults with declarative configuration, you need to take certain precautions.
For larger teams with many contributors, or organizations with multiple teams,
we recommend splitting vault configuration and managing it separately.

**Why split out vault configuration?**

* Vault are closer to infrastructure than other {{site.base_gateway}} configurations.
Separation of routing policies from infrastructure-specific configurations helps
keep configuration organized.
* Vaults may be shared across teams. In this case, one specific team shouldn't
control the vault's configuration. One team changing the vault a can have
disastrous impact on another team.
* If a vault is deleted while in use -- that is, if there are still references to
secrets in a vault in configuration -- it can lead to total loss of proxy capabilities.
Those secrets would be unrecoverable.

**How should I manage my vault configuration with decK?**

To keep your environment secure and avoid taking down your proxies by accident, make sure to:

* Manage vaults with distributed configuration via tags.
* Use a separate [RBAC role, user, and token](/gateway/latest/admin-api/rbac/reference)
to manage vaults. Don't use a generic admin user.
* Set up a separate CI pipeline for vaults.

### Manage vaults with distributed configuration

Avoid mixing vault configuration with other {{site.base_gateway}} entities.
Instead, manage vaults with [distributed configuration](/deck/latest/guides/distributed-configuration) via tags.

Tag your vault in the declarative configuration file:

```yaml
_format_version: "3.0"
vaults:
- config:
    prefix: MY_SECRET_
  description: ENV vault for secrets
  name: env
  prefix: my-env-vault
  tags:
    - env-vault
```

When updating the vault, `deck dump` the configuration with the `--select-tag` flag:

```sh
deck dump --select-tag env-vault
```

Make your changes to the vault, then push it back up with `deck sync`.
You don't need to specify `--select-tag` in this case, as decK recognizes the
tag in the declarative configuration file that you're syncing and updates
those entities accordingly.
