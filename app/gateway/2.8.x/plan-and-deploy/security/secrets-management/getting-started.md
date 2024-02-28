---
title: Get Started with Secrets Management
---

This feature is currently in beta state and isn't fully supported. APIs are subject to change.


Secrets are generally confidential values that should not appear in plain text in the application.
There are several products that help you store, retrieve, and rotate these secrets securely.
{{site.base_gateway}} offers a mechanism to set up references to these secrets which makes your {{site.base_gateway}} installation more secure.

## Getting started

{:.note}
> When running {{site.base_gateway}} in hybrid or DB-less mode, secrets management is only supported in {{site.base_gateway}} 2.8.1.3 or later.

The following example uses the most basic form of secrets management: storing secrets in environment variables. In this example, you will replace a plaintext password to your PostgreSQL database with a reference to an environment variable.

You can also store secrets in a secure vault backend. For a list of supported vault backend implementations, see the [Backends Overview](/gateway/{{page.release}}/plan-and-deploy/security/secrets-management/backends/).

In this example we'll replace our plaintext password to our PostgreSQL database with a reference. To do so, please define your environment variable and assign a secret value to it.

### Define a reference

Define your environment variable and assign a secret value to it:

```bash
export MY_SECRET_POSTGRES_PASSWORD="opensesame"
```

Next, set up a reference to this environment variable so that {{site.base_gateway}} can find this secret. We use a Uniform Resource Locator (URL) format for this.

In this case, the reference would look like this:

```bash
{vault://env/my_secret_postgres_password}
```

Where:

* `vault` is the scheme (protocol) that we use to indicate that this is a secret.
* `env` is the name of the backend [(Environment Variables)](/gateway/{{page.release}}/plan-and-deploy/security/secrets-management/backends/env/), since we're storing the secret in a ENV variable.
* `my_secret_postgres_password` corresponds to the environment variable that you just defined.

Note that the reference is wrapped in curly braces.

### Using the reference

You can specify configuration options using environment variables or by directly updating the `kong.conf` configuration file.

#### Environment variable

Set the `KONG_PG_PASSWORD` environment variable to the following, adjusting `my-secret-postgres-password` to your own password object name:

```bash
KONG_PG_PASSWORD={vault://env/my-secret-postgres-password}
```

#### Configuration file

The `kong.conf` file contains the property `pg_password`.
Replace the original value with the following, adjusting `my-secret-postgres-password` to your own password object name:

```bash
pg_password={vault://env/my-secret-postgres-password}
```

Upon startup, {{site.base_gateway}} tries to detect and transparently resolve references.

{:.note}
> For quick debugging or testing, you can use the [CLI for vaults](/gateway/{{page.release}}/plan-and-deploy/security/secrets-management/advanced-usage/#vaults-cli).

See the [Advanced Usage](/gateway/{{page.release}}/plan-and-deploy/security/secrets-management/advanced-usage/) documentation for more information on the configuration options for each vault backend.
