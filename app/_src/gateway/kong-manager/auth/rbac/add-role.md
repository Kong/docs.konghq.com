---
title: Add a Role and Permissions
badge: enterprise
---

Roles make it easy to logically group and apply the same
set of permissions to admins. Permissions may be
customized in detail, down to individual actions and endpoints.

{{site.base_gateway}} includes default roles for standard
use cases, e.g. inviting additional super admins,
inviting admins that may only `read` endpoints.

This guide describes how to create a custom role in Kong
Manager for a unique use case. As an alternative, if a
super admin wants to create a role with the Admin API,
it is possible to do so using
[`/rbac/roles`](/gateway/{{page.release}}/admin-api/rbac/reference/#add-a-role).
To add permissions to the new role, use
[`/rbac/roles/{name_or_id}/endpoints`](/gateway/{{page.release}}/admin-api/rbac/reference/#add-a-role-endpoint-permission)
for endpoints or
[`/rbac/roles/{name_or_id}/entities`](/gateway/{{page.release}}/admin-api/rbac/reference/#add-a-role-entity-permission)
for specific entities.

## Prerequisites

* Authentication and RBAC are [enabled](/gateway/{{page.release}}/kong-manager/auth/rbac/enable/)
* You have [super admin permissions](/gateway/{{page.release}}/kong-manager/auth/super-admin/)
or a user that has `/admins` and `/rbac` read and write access

## Add a role and permissions

1. From the **Admins** page, click the
**Add Role** button.

1. On the **Add Role** form, name the **Role** according to the
**Permissions** you want to grant.

    It may be helpful for future reference to include
    a brief comment describing the reason for the permissions or
    a summary of the role.

1. Click the **Add Permissions** button and fill out the form.
Add the endpoint permissions by marking the appropriate checkbox.

1. Click **Add Permission to Role** to see the permissions listed on the form.

1. To forbid access to certain endpoints, click **Add Permission**
again and use the **negative** checkbox.

1. Submit the form to see the new roles appear on the
admins page.
