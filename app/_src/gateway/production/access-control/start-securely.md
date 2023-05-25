---
title: Start Kong Gateway Securely
badge: enterprise
---

To secure the Admin API or Kong Manager, a Super Admin account is
required.

The Super Admin has the ability to invite other Admins and
restrict their access based on Permissions of Roles within
Workspaces.

The first Super Admin account is created during database migrations
following the guide below. It may only be added once.

## Prerequisites

After [installing {{site.base_gateway}}](/gateway/{{page.kong_version}}/install/),
either modify the configuration file or set environment variables for
the following properties:

* `enforce_rbac` will force all Admin API requests to require a
`Kong-Admin-Token`. The Admin associated with the `Kong-Admin-Token`
must have adequate Permissions in order for the request to succeed.

* If using Kong Manager, select the type of authentication that Admins
should use to log in. For the purpose of this guide, `admin_gui_auth`
may be set to `basic-auth`. See
[Securing Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth/) for other types
of authentication.

Configure RBAC with basic authentication:

{% include_cached /md/admin-listen.md desc='long' kong_version=page.kong_version %}

```
enforce_rbac = on
admin_gui_auth = basic-auth
admin_gui_session_conf = {"secret":"secret","storage":"kong","cookie_secure":false}
admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl
```

Kong Manager uses the Sessions plugin in the background.
This plugin (configured with `admin_gui_session_conf`) requires a secret and is configured securely by default.

* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
{% if_version lte:3.1.x %}
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`.
{% endif_version %}
{% if_version gte:3.2.x %}
* If using different domains for the Admin API and Kong Manager, `cookie_same_site` must be set to `Lax`.
{% endif_version %}

Learn more about these properties in [Session Security in Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth/sessions/#session-security), and see [example configurations](/gateway/{{page.kong_version}}/kong-manager/auth/sessions#example-configurations).

## Step 1

Set a password for the Super Admin. This environment variable must
be present in the environment where database migrations will run.

{:.important}
> **Important**: Setting your Kong password (`KONG_PASSWORD`) using a value containing four ticks (for example, `KONG_PASSWORD="a''a'a'a'a"`) causes a PostgreSQL syntax error on bootstrap. To work around this issue, do not use special characters in your password.

```
export KONG_PASSWORD=<password-only-you-know>
```

This automatically creates a user, `kong_admin`, and a password that
can be used to log in to Kong Manager. This password may also be
used as a `Kong-Admin-Token` to make Admin API requests.

**Note:** only one Super Admin may be created using this method, and only
on a fresh installation with an empty database. If one is not created during migrations,
follow [this guide](/gateway/{{page.kong_version}}/kong-manager/auth/rbac/add-admin/) to remediate.

Future migrations will not update the password or create additional Super Admins.
To add additional Super Admins it is necessary to
[invite a new user as a Super Admin in Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth//super-admin/).

## Step 2

Issue the following command to prepare your data store by running the Kong migrations:

```
kong migrations bootstrap [-c /path/to/kong.conf]
```

## Step 3

Start Kong:

```
kong start [-c /path/to/kong.conf]
```

**Note:** the CLI accepts a configuration option (`-c /path/to/kong.conf`)
allowing you to point to [your own configuration](/gateway/{{page.kong_version}}/reference/configuration/#configuration-loading).

## Step 4

To test that {{site.base_gateway}} has successfully started with a Super Admin,
visit Kong Manager's URL. By default, it is on port `:8002`.

The username is `kong_admin` and the password is the one set in
[Step 1](#step-1).
