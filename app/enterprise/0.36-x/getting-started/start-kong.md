---
title: How to Start Kong Enterprise Securely
toc: false
---
#### Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step 1](#step-1)
- [Step 2](#step-2)
- [Step 3](#step-3)
- [Step 4](#step-4)
- [Default Ports](#default-ports)
- [Next Steps](#next-steps)

### Introduction

To secure the Admin API or Kong Manager, a **Super Admin** account is 
required.

The **Super Admin** has the ability to invite other **Admins** and 
restrict their access based on **Permissions** of **Roles** within 
**Workspaces**.

The first **Super Admin** account is created during database migrations 
following the guide below. It may only be added once.

### Prerequisites

After [installing Kong Enterprise](/enterprise/{{page.kong_version}}/deployment/installation/overview/), 
either modify the configuration file or set environment variables for 
the following properties:

* `enforce_rbac` will force all Admin API requests to require a 
`Kong-Admin-Token`. The **Admin** associated with the `Kong-Admin-Token`
must have adequate **Permissions** in order for the request to succeed.

* If using Kong Manager, select the type of authentication that **Admins** 
should use to log in. For the purpose of this guide, `admin_gui_auth` 
may be set to `basic-auth`. See 
[Securing Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/security) for other types 
of authentication.

For a simple configuration to use for the subsequent Getting 
Started guides:

```
enforce_rbac = on
admin_gui_auth = basic-auth
admin_gui_session_conf = { "secret":"set-your-string-here" }
```

⚠️**Important:** the **Sessions Plugin** requries a secret and is configured securely by default. 
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`. 
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`. 
Learn more about these properties in [Session Security in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security), and see [example configurations](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#example-configurations).

## Step 1

Set a password for the **Super Admin**. This environment variable must 
be present in the environment where database migrations will run. 

```
$ export KONG_PASSWORD=<password-only-you-know>
```

This automatically creates a user, `kong_admin`, and a password that 
can be used to log in to Kong Manager. This password may also be 
used as a `Kong-Admin-Token` to make Admin API requests.

**Note:** only one **Super Admin** may be created using this method, and only
on a fresh installation with an empty database. If one is not created during migrations, 
follow [this guide](/enterprise/{{page.kong_version}}/kong-manager/authentication/super-admin/#how-to-create-your-first-super-admin-account-post-installation) to remediate. 

Future migrations will not update the password or create additional **Super Admins**. 
To add additional **Super Admins** it is necessary to 
[invite a new user as a **Super Admin** in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/administration/admins/invite/#how-to-invite-a-new-admin-from-the-organization-page).

## Step 2

Issue the following command to prepare your datastore by running the Kong migrations:

```
$ kong migrations bootstrap [-c /path/to/kong.conf]
```

## Step 3

Start Kong:

```
$ kong start [-c /path/to/kong.conf]
```

**Note:** the CLI accepts a configuration option (`-c /path/to/kong.conf`)
allowing you to point to [your own configuration](/1.0.x/configuration/#configuration-loading).

## Step 4

To test that Kong Enterprise has successfully started with a **Super Admin**, 
visit Kong Manager's URL. By [default](#default-ports), it is on port `:8002`. 

The username is `kong_admin` and the password is the one set in 
[Step 1](#step-1).

### Default Ports

By default, Kong Enterprise listens on the following ports:

- [`:8000`](/enterprise/{{page.kong_version}}/property-reference/#proxy_listen): incoming HTTP traffic from **Consumers**, and forwarded to upstream 
  **Services**.
- [`:8443`](/enterprise/{{page.kong_version}}/property-reference/#proxy_listen): incoming HTTPS traffic. This port behaves similarly to the `:8000` 
  port, except that it expects HTTPS traffic only. 
- [`:8003`](/enterprise/{{page.kong_version}}/property-reference/#portal_gui_listen): Dev Portal listens for HTTP traffic, assuming Dev Portal is **enabled**.
- [`:8446`](/enterprise/{{page.kong_version}}/property-reference/#portal_gui_listen): Dev Portal listens for HTTPS traffic, assuming Dev Portal is **enabled**.
- [`:8004`](/enterprise/{{page.kong_version}}/property-reference/#portal_api_listen): Dev Portal **`/files`** traffic over HTTP, assuming the Dev Portal is **enabled**.
- [`:8447`](/enterprise/{{page.kong_version}}/property-reference/#portal_api_listen): Dev Portal **`/files`** traffic over HTTPS, assuming the Dev Portal is **enabled**.
- [`:8001`](/enterprise/{{page.kong_version}}/property-reference/#admin_api_uri): Admin API listens for HTTP traffic.
- [`:8444`](/enterprise/{{page.kong_version}}/property-reference/#admin_api_uri): Admin API listens for HTTPS traffic.
- [`:8002`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_listen): Kong Manager listens for HTTP traffic.
- [`:8445`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_listen): Kong Manager listens for HTTPS traffic.

### Next Steps

With Kong Enterprise started and the **Super Admin** logged in, it is now 
possible to create any entity in Kong. 

Next, see how to segment the Kong cluster into 
[**Workspaces**](/enterprise/{{page.kong_version}}/getting-started/add-workspace).
