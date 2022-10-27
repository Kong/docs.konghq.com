---
title: Secret Management with decK
content_type: how-to
---

decK supports secret references for encoded values in {{site.base_gateway}}.
You can store your secrets a [vault backend](/gateway/latest/kong-enterprise/secrets-management/),
then reference them in your declarative configuration files.

This guide covers storing values as secrets. You can use secrets to store sensitive data, such as credentials.

## {{site.base_gateway}} secrets or decK environment variables?

With decK, instead of checking credentials into Git, you can choose one of the following options:

Option | Description | Why use this method?
-------|-------------|---------------------
[decK environment variables](/deck/latest/guides/environment-variables) | Store values as environment variables and access them directly through decK. {{site.base_gateway}} is not involved. | • You can use this option for environment-specific values. <br><br> • This method can store any configuration values used by {{site.base_gateway}} entities. It can't secure values from `kong.conf`. <br><br> • Available for all {{site.base_gateway}} packages: open-source, Enterprise Free mode, and Enterprise licensed mode.
Secrets in {{site.base_gateway}} | Store values as secrets in a vault, then reference the secrets with a vault reference. In this case, {{site.base_gateway}} manages the secrets with a `vaults` entity. | • This option is more secure. <br><br> • You can use secrets to store many sensitive values, including parameters in Kong's configuration (`kong.conf`). See [Secrets Management in {{site.base_gateway}}](src/gateway/kong-enterprise/secrets-management/#what-can-be-stored-as-a-secret) for a full list. <br><br> • Secrets management is only available for {{site.base_gateway}} Enterprise packages. It is not available for open-source {{site.base_gateway}}. <br>The environment variable vault can be used in Free mode without a license, while all other vault backends require a license.

## Configure a secret vault

Set up a secret vault using the {{site.base_gateway}} `vaults` entity.

For example, to set up a vault using environment variables as the backend,
configure a prefix for the vault, and a prefix for the reference:

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

{:.note}
> **Note**: We recommend splitting out `vault` declarative configuration using [distributed configuration](/deck/latest/guides/distributed-configuration).

## Store and reference secrets

Store your sensitive values in a secret:

```sh
export MY_SECRET_CERT="<cert data>" \
export MY_SECRET_KEY="<key data>"
```

Now you can reference the secret in subsequent configuration:

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
