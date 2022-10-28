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
vauts.config | Stores the configuration for a particular vault. The configuration values required depend on the vault that you are using. In this example, the `vaults.config.prefix` value configures the prefix for the environment variable that the value will be stored in. See the individual [vault backends](/gateway/latest/kong-enterprise/secrets-management/backends/) to find the required configuration values for your particular vault type.
vaults.description | An optional description for your vault.
vaults.name | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`.
vaults.prefix | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://my-env-vault/<some-secret>}`.

{{site.base_gateway}} also supports HashiCorp Vault, GCP, and AWS as [vault backends](/gateway/latest/kong-enterprise/secrets-management/backends/).

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

Split out `vault` entity configuration using [distributed configuration](/deck/latest/guides/distributed-configuration).
