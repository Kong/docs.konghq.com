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
  hashing, signing or encryption.

{{site.base_gateway}} lets you store certain values in a vault.
By storing sensitive values as secrets, you ensure that they are not
visible in plaintext throughout the platform, in places such as `kong.conf`,
in declarative configuration files, logs, or in the Kong Manager UI. Instead,
you can reference each secret with a `vault` reference. For example the following
reference resolves to a value of environment variable `MY_SECRET_POSTGRES_PASSWORD`:

```
{vault://env/my-secret-postgres-password}
```

In this way, secrets management becomes centralized.

## Referenceable values

A secret reference points to a string value (we don't support other types currently).
The vault backend may store multiple related secrets inside an object, but the reference
should always point to a key that resolves to a string value. For example a reference:

```
{vault://hcv/pg/username}
```

Would point to a secret object called `pg` inside a Hashicorp Vault which may return value of:

```json
{
  "username": "john",
  "password": "doe"
}
```

Kong receives the payload and extracts the `"username"` value of `"john"` for the secret reference of
`{vault://hcv/pg/username}`.

The most of the [Kong Configuration](/gateway/{{page.kong_version}}/reference/configuration/) values
can be stored as a secret, such as [pg_user](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings) and
[pg_password](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings). There are some limitation currently,
for example [ssl_cert_key](/gateway/{{page.kong_version}}/reference//configuration/#ssl_cert_key)
configures a certificate key `file path`, and we don't yet support storing the certificate key content
to vaults (or even environment variables) for `kong.conf` settings that use file paths.

The [Kong License](/gateway/{{page.kong_version}}/kong-enterprise/licenses/), usually configured with
an `KONG_LICENSE_DATA` environment variable, can be stored as a secret.


The Kong Admin API [certificate object](/gateway/{{page.kong_version}}/admin-api/#certificate-object)
can be stored as a secret.

The following plugins have fields that can be stored as secrets in a
vault backend. These fields are labelled as `referenceable`. See the
documentation for each plugin to identify the referenceable fields:

* [ACME](/hub/kong-inc/acme/)
* [AWS Lambda](/hub/kong-inc/aws-lambda/)
* [Azure Functions](/hub/kong-inc/azure-funtions/)
* [Forward Proxy](/hub/kong-inc/forward-proxy/)
* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/)
* [Kafka Log](/hub/kong-inc/kafka-log/)
* [Kafka Upstream](/hub/kong-inc/kafka-upstream/)
* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/)
* [Loggly](/hub/kong-inc/loggly/)
* [OpenID Connect](/hub/kong-inc/openid-connect/)
* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/)
* [Rate Limiting](/hub/kong-inc/rate-limiting/)
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
* [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/)
* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
* [Session](/hub/kong-inc/session/)
* [Vault Authentication](/hub/kong-inc/vault-auth/)

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
