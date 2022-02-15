---
title: Secrets Management
beta: true
---

A secret is any sensitive piece of information required for API gateway
operations. Secrets may be part of the core {{site.base_gateway}} configuration,
they may be used in plugins, or they might be part of configuration associated
with APIs serviced by the gateway.

Some of the most common types of secrets used by {{site.base_gateway}} include:

* Datastore usernames and passwords, used with PostgreSQL and Redis
* Private X.509 certificates
* API keys
* Sensitive plugin configuration fields, generally used for authentication

{{site.base_gateway}} lets you store certain values in a vault.
By storing sensitive values as secrets, you ensure that they are not
visible in plaintext throughout the platform, in places such as `kong.conf`,
in declarative configuration files, logs, or in the Kong Manager UI. Instead,
you can use reference each secret with a `vault` reference. For example:

```
{vault://env/my_secret_postgres_password}
```

In this way, secrets management becomes centralized.

## Referenceable values

The Kong Admin API certificate object can be stored as a secret.

The following plugins have fields that can be stored as secrets in a backend
vault:

* Forward Proxy Advanced
* GraphQL Rate Limiting
* Kafka Log
* Kafka Upstream
* LDAP Authentication Advanced
* OpenID Connect
* Proxy Cache Advanced
* Rate Limiting Advanced

## Supported backends

{{site.base_gateway}} supports the following vault backends:
* Environment variables
* AWS Secrets Manager
* Hashicorp Vault

See the [backends overview](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/)
for more information about each option.

## Beta limitations

This feature is currently in beta. This means it has limited support from
Kong and the functionality may change in the future.

**Do not** implement this feature in a product environment.

* There is no `set` or secrets rotation support in the beta.
* In this version, this feature isn't enabled by default. To test it out, start
{{site.base_gateway}} with `KONG_VAULTS=bundled` if running Kong in a container,
or with `vaults=bundled` set in `kong.conf`.
* The API endpoint is suffixed with `-beta` to avoid any possible conflicts. This
endpoint will change once the beta is over.

## Get started

To test out secrets management, see the following topics:
* [Get started with secrets management](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/getting-started/)
* [Backends overview](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/)
* [Reference format](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/reference-format/)
* [Advanced usage](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/advanced-usage/)
