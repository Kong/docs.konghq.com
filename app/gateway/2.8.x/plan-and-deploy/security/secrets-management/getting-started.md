---
title: Get Started with Secrets Management
beta: true
---

This feature is currently in beta state and isn't fully supported. APIs are subject to change.


Secrets are generally confidential values that should not appear in plain text in the application. There are several products that help you
store, retrieve, and rotate these secrets securely. Kong Gateway offers a mechanism to set up references to these secrets which makes your Kong Gateway
installation more secure.

## Getting started

{:.note}
> This feature isn't enabled by default in this version of Kong.
><br>
> Start Kong Gateway with `KONG_VAULTS=bundled`.

The following example uses the most basic form of secrets management: storing secrets in environment variables. In this example, you will replace a plaintext password to your Postgres database with a reference to an environment variable.

You can also store secrets in a secure vault backend. For a list of supported vault backend implementations, see the [Backends Overview](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends).

In this example we'll replace our plaintext password to our Postgres database with a reference. To do so, please define your environment variable and assign a secret value to it.

### Define a reference

Define your environment variable and assign a secret value to it:

```bash
export MY_SECRET_POSTGRES_PASSWORD="opensesame"
```

Next, set up a `reference` to this environment variable so that Kong Gateway can find this secret. We use a Uniform Resource Locator (URL) format for this.

In this case, the reference would look like this:

```bash
{vault://env/my_secret_postgres_password}
```

Where:

* `vault` is the scheme (protocol) that we use to indicate that this is a secret.
* `env` is the name of the backend [(Environment Variables)](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/env), since we're storing the secret in a ENV variable.
* `my_secret_postgres_password` corresponds to the environment variable that you just defined.

Note that the reference is wrapped in curly braces.

### Using the reference

You can specify configuration options using environment variables or by directly updating the `kong.conf` configuration file.

* Environment variable

```bash
KONG_PG_PASSWORD={vault://env/my-secret-postgres-password}
```

* Configuration file

the kong.conf has a key called "pg_password". Replace the original value with

```bash
pg_password={vault://env/my-secret-postgres-password}
```

Upon startup, Kong will try to detect and transparently resolve references.

{:.note}
>For quick debug/testing you can use the new [CLI for vaults](/gateway/2.8.x/plan-and-deploy/security/secrets-management/advanced-usage/#vaults-cli)

See the [Advanced Usage](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/advanced-usage) documentation for more information on the configuration options for each vault backend.
