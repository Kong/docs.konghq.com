---
title: Authentication and Authorization in Kong Manager
---

Kong Manager enables users with admin accounts to access Kong entities such
as services, plugins, and consumers.

The following document summarizes Kong Manager's controls for *authentication*
and *authorization*.

## Configuring authentication

{{site.base_gateway}} comes packaged with authentication plugins that can be used
to secure Kong Manager. Unlike enabling a plugin on an entity or cluster,
enabling an authentication plugin for *only* Kong Manager requires turning
on `enforce_rbac`, setting `admin_gui_auth` to the desired type,
configuring `admin_gui_session_conf`, and optionally configuring `admin_gui_auth_conf`
if needed.

Kong Manager currently supports the following authentication plugins:

* [Basic Auth](/gateway/{{page.kong_version}}/kong-manager/authentication/basic/)
* [OIDC](/gateway/{{page.kong_version}}/kong-manager/authentication/oidc-mapping/)
* [LDAP](/gateway/{{page.kong_version}}/kong-manager/authentication/ldap/)

In addition to the authentication plugins above, the
[Sessions plugin](/gateway/{{page.kong_version}}/kong-manager/authentication/sessions/)
is required when RBAC is enabled. It sends HTTP cookies to authenticate
client requests and maintain session information.

The Sessions plugin requires a secret and is configured
securely by default.
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
* If using different domains for the Admin API and Kong Manager,
`cookie_samesite` must be set to `off`.

Learn more about these properties in
[Session Security in Kong Manager](/gateway/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security),
and see [example configurations](/gateway/{{page.kong_version}}/kong-manager/authentication/sessions/#example-configurations).

## Access control with roles and workspaces

An admin belongs to a workspace and should have at least one role
with a set of permissions. If an admin is in a workspace *without*
a role, they will not have the ability to see or interact with anything.

By creating separate
[workspaces](/gateway/{{page.kong_version}}/kong-manager/workspaces/workspaces/),
 an organization with multiple teams can segment its Kong cluster so that
 different teams don't have access to each other's Kong entities.

{{site.base_gateway}} implements 
[Role-Based Access Control (RBAC)](/gateway/{{page.kong_version}}/kong-manager/rbac/).
Admins are assigned roles that have clearly defined permissions. A
super admin has the ability to:

* Further customize permissions
* Create entirely new roles
* Invite or deactivate admins
* Assign or revoke their roles

In Kong Manager, limiting permissions also restricts the visibility of the
application interface and navigation.
