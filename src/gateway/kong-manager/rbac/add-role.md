---
title: Add a Role and Permissions
badge: enterprise
---

### Introduction

**Roles** make it easy to logically group and apply the same
set of **Permissions** to **Admins**. **Permissions** may be
customized in detail, down to individual actions and endpoints.

Kong Enterprise includes default **Roles** for standard
use cases, e.g. inviting additional **Super Admins**,
inviting **Admins** that may only `read` endpoints.

This guide describes how to create a custom **Role** in Kong
Manager for a unique use case. As an alternative, if a
**Super Admin** wants to create a **Role** with the Admin API,
it is possible to do so using
[`/rbac/roles`](/gateway/{{page.kong_version}}/admin-api/rbac/reference/#add-a-role).
To add **Permissions** to the new **Role**, use
[`/rbac/roles/{name_or_id}/endpoints`](/gateway/{{page.kong_version}}/admin-api/rbac/reference/#add-a-role-endpoint-permission)
for endpoints or
[`/rbac/roles/{name_or_id}/entities`](/gateway/{{page.kong_version}}/admin-api/rbac/reference/#add-a-role-entity-permission)
for specific entities.

### Prerequisites

* [`enforce_rbac = on`](/gateway/{{page.kong_version}}/reference/configuration/#enforce_rbac)
* Kong Enterprise has [started](/gateway/{{page.kong_version}}/kong-production/running-kong/start-kong-securely/)
* Logged in to Kong Manager as a **Super Admin**

## Step 1

On the **Admins** page, to create a new **Role**, click the
**Add Role** button at the top right of the list of **Roles**.

## Step 2

On the **Add Role** form, name the **Role** according to the
**Permissions** you want to grant.

**Note:** It may be helpful for future reference to include
a brief comment describing the reason for the **Permissions** or
a summary of the **Role**.

## Step 3

Click the **Add Permissions** button and fill out the form. Add the endpoint **Permissions** by marking the appropriate checkbox.

## Step 4

Click **Add Permission to Role** to see the permissions listed on the form.

## Step 5

To forbid access to certain endpoints, click **Add Permission**
again and use the **negative** checkbox.

## Step 6

Submit the form and see the new **Role** appear on the
**Admins** page.
