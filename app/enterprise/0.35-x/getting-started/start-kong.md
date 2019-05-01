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
- [Next Steps](#next-steps)

### Introduction

To secure the Admin API or Kong Manager, a **Super Admin** account is 
required.

The **Super Admin** has the ability to invite other **Admins** and 
restrict their access based on **Permissions** of **Roles** within 
**Workspaces**.

The first **Super Admin** account is created during database migrations 
following the guide below.

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
```

## Step 1

Set a password for the **Super Admin**. This environment variable must 
be present in the environment where database migrations will run. 

```
$ export KONG_PASSWORD=<password-only-you-know>
```

This automatically creates a user, `kong_admin`, and a password that 
can be used to log in to Kong Manager. This password may also be 
used as a `Kong-Admin-Token` to make Admin API requests.

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

### Next Steps
