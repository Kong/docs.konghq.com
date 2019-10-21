---
title: Securing Kong Manager
book: admin_gui
---

## What Can Admins Do in Kong Manager?

Kong Manager enables users with **Admin** accounts to access Kong entities such 
as **Services**, **Plugins**, and **Consumers.**

The following document summarizes Kong Manager's controls for *authentication* 
and *authorization*.

## Configuring Authentication

Kong Enterprise comes packaged with **Authentication Plugins** that can be used 
to secure Kong Manager. Unlike enabling a **Plugin** on an entity or cluster, 
enabling an **Authentication Plugin** for *only* Kong Manager requires turning 
on `enforce_rbac`, setting `admin_gui_auth` to the desired type, proper 
configuration of `admin_gui_session_conf`, and configuring `admin_gui_auth_conf` 
if needed.

Kong Manager currently supports the following **Authentication Plugins**:

* [**Basic Auth**](/enterprise/{{page.kong_version}}/kong-manager/authentication/basic/)
* [**OIDC**](/enterprise/{{page.kong_version}}/kong-manager/authentication/oidc/)
* [**LDAP**](/enterprise/{{page.kong_version}}/kong-manager/authentication/ldap/)

In addition to the **Authentication Plugins** above, the new 
[**Sessions Plugin**](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/) 
is now required when RBAC is enabled. It sends HTTP cookies to authenticate 
client requests and maintain session information.

⚠️**Important:** the **Sessions Plugin** requries a secret and is configured 
securely by default. 
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`. 
* If using different domains for the Admin API and Kong Manager, 
`cookie_samesite` must be set to `off`. 
Learn more about these properties in 
[Session Security in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security), 
and see [example configurations](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#example-configurations).

## Access Control with Roles and Workspaces

An **Admin** belongs to a **Workspace** and should have at least one **Role** 
with a set of **Permissions**. If an **Admin** is in a **Workspace** *without* 
a **Role**, they will not have the ability to see or interact with anything.

By creating separate 
[**Workspaces**](/enterprise/{{page.kong_version}}/kong-manager/administration/workspaces/workspaces/),
 an organization with multiple teams can segment its Kong cluster so that 
 different teams do not have access to each other's Kong entities. 

Kong Enterprise implements Role-Based Access Control 
([RBAC](/enterprise/{{page.kong_version}}/kong-manager/administration/rbac/rbac/)). 
**Admins** are assigned **Roles** that have clearly defined **Permissions**. A 
**Super Admin** has the ability to: 

* further customize **Permissions**
* create entirely new **Roles**
* invite or deactivate **Admins**
* assign or revoke their **Roles**

In Kong Manager, limiting **Permissions** also restricts the visibility of the 
application interface and navigation. Learn more about RBAC in Kong Manager in 
our guide 
[RBAC in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/administration/rbac/rbac).
