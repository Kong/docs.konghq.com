---
title: Secrets Management
---

A secret is any sensitive piece of information required for API gateway
operations. Secrets may be part of the core {{site.base_gateway}} configuration,
they may be used in plugins, or they might be part of configuration associated
with APIs serviced by the gateway.

Some of the most common types of secrets used by {{site.base_gateway}} include:

* Data store usernames and passwords, used with PostgreSQL and Redis
* Private X.509 certificates
* API keys
* Sensitive plugin configuration fields, generally used for authentication,
  hashing, signing, or encryption.

{{site.base_gateway}} lets you store certain values in a vault.
By storing sensitive values as secrets, you ensure that they are not
visible in plaintext throughout the platform, in places such as `kong.conf`,
in declarative configuration files, logs, or in the Kong Manager UI. Instead,
you can reference each secret with a `vault` reference.

For example, the following reference resolves to the environment variable `MY_SECRET_POSTGRES_PASSWORD`:

```
{vault://env/my-secret-postgres-password}
```

In this way, secrets management becomes centralized.

## Referenceable values

A secret reference points to a string value. No other data types are currently supported.

The vault backend may store multiple related secrets inside an object, but the reference
should always point to a key that resolves to a string value. For example, the following reference:

```
{vault://hcv/pg/username}
```

Would point to a secret object called `pg` inside a HashiCorp Vault, which may return the following value:

```json
{
  "username": "john",
  "password": "doe"
}
```

<!-- vale off -->
Kong receives the payload and extracts the `"username"` value of `"john"` for the secret reference of
`{vault://hcv/pg/username}`.
<!-- vale on -->

## What can be stored as a secret?

Most of the [Kong configuration](/gateway/{{page.kong_version}}/reference/configuration/) values
can be stored as a secret, such as [`pg_user`](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings) and
[`pg_password`](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings).

{:.note}
> **Limitation:** {{site.base_gateway}} doesn't currently support storing certificate key content into vaults or environment variables for `kong.conf` settings that use file paths. For example, [ssl_cert_key](/gateway/{{page.kong_version}}/reference/configuration/#ssl_cert_key) configures a certificate key `file path` which can't be stored as a reference.

The [Kong license](/gateway/{{page.kong_version}}/licenses/), usually configured with
a `KONG_LICENSE_DATA` environment variable, can be stored as a secret.

The Kong Admin API [certificate object](/gateway/{{page.kong_version}}/admin-api/#certificate-object)
can be stored as a secret.

### Referenceable plugin fields

Some plugins have fields that can be stored as secrets in a
vault backend. These fields are labelled as `referenceable`. 

The following plugins support vault references for specific fields. 
See each plugin's documentation for more information on each field:

{% assign hub = site.data.ssg_hub %}
{% assign kong_extns = hub | where: "publisher", "Kong Inc." %}

<table>
  <thead>
      <th>Plugin</th>
      <th>Referenceable fields</th>
  </thead>
  <tbody>
    {% for extn in kong_extns %}
    {% assign ref = extn.params.config | find: "referenceable", "true" %}
    {% if ref %}
      <tr>
        <td>
          <a href="{{extn.url}}">{{ extn.name }}</a>
        </td>
        <td> 
          {% for c in extn.params.config %}
            {% if c.referenceable == true %}
            <code>{{ c.name }}</code>
            {% endif %}
          {% endfor %}
        </td>
      </tr>
      {% endif %}
    {% endfor %}
    <tr>
      <td>
        <a href="/hub/kong-inc/vault-auth/">Vault Authentication</a>
      </td>
      <td> 
        <code>vaults.vault_token</code>
        <code>vault_credentials.secret_token</code>
      </td>
    </tr>
  </tbody>
</table>

## Supported backends

{{site.base_gateway}} supports the following vault backends:
* Environment variables
* AWS Secrets Manager
* GCP Secrets Manager
* HashiCorp Vault

See the [backends overview](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/)
for more information about each option.

## Get started

For further information on secrets management, see the following topics:
* [Get started with secrets management](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/getting-started/)
* [Backends overview](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/)
* [Reference format](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/reference-format/)
* [Advanced usage](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/advanced-usage/)
