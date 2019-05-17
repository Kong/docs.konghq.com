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

**Note:** only one **Super Admin** may be created using this method. 
Future migrations will not override it or create additional **Super Admins**. 
To do so, it is necessary to 
[invite new users as **Super Admins** in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/administration/admins/invite/#how-to-invite-a-new-admin-from-the-organization-page).

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
visit Kong Manager's URL. By default, it is `http://localhost:8002`. 

The username is `kong_admin` and the password is the one set in 
[Step 1](#step-1).

### Next Steps

With Kong Enterprise started and the **Super Admin** logged in, it is now 
possible to create any entity in Kong. 

Next, see how to segment the Kong cluster into 
[**Workspaces**](/enterprise/{{page.kong_version}}/getting-started/add-workspace).