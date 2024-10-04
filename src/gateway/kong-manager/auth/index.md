---
title: Authentication and Authorization in Kong Manager
breadcrumb: Overview
badge: enterprise
---

Kong Manager enables users with admin accounts to access Kong entities such
as services, plugins, and consumers.


## Configuring authentication

{{site.base_gateway}} comes packaged with authentication plugins that can be used
to secure Kong Manager.
To enable to an authentication plugin for *only* Kong Manager, you need to set the following properties in [`kong.conf`](/gateway/{{page.release}}/production/kong-conf/):
* Set `enforce_rbac` to `on`
* Set `admin_gui_auth` to the desired authentication type (for example, `basic-auth`)
* Configure `admin_gui_session_conf` with a session secret
* Optionally configure `admin_gui_auth_conf` with custom configuration for your authentication type

The configuration details depend on your authentication type.

Kong Manager currently supports the following authentication plugins:

* [Basic Auth](/gateway/{{page.release}}/kong-manager/auth/basic/)
* [OIDC](/gateway/{{page.release}}/kong-manager/auth/oidc/mapping/)
* [LDAP](/gateway/{{page.release}}/kong-manager/auth/ldap/configure/)

In addition to the authentication plugins above, the
[Sessions plugin](/gateway/{{page.release}}/kong-manager/auth/sessions/)
is required when RBAC is enabled. It sends HTTP cookies to authenticate
client requests and maintain session information.

{:.note}
> **Note:** Kong Manager does not directly offer 2FA, MFA, OTP, CAPTCHA, or reCAPTCHA. 
However, if you configure Kong Manager to use [OIDC authentication](/gateway/{{page.release}}/kong-manager/auth/oidc/configure/), then you can provide secondary authentication via your OIDC provider.

The **Sessions plugin** (configured with `admin_gui_session_conf`) requires a secret and is configured securely by default.
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
{% if_version lte:3.1.x -%}
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`.
{% endif_version -%}
{% if_version gte:3.2.x -%}
* If using different domains for the Admin API and Kong Manager, `cookie_same_site` must be set to `Lax`.
{% endif_version %}

Learn more about these properties in
[Session Security in Kong Manager](/gateway/{{page.release}}/kong-manager/auth/sessions/#session-security),
and see [example configurations](/gateway/{{page.release}}/kong-manager/auth/sessions/#example-configurations).

## Access control with roles and workspaces

Many organizations have strict security requirements. For example, organizations need the ability to segregate the duties of an administrator to ensure that a mistake or malicious act by one administrator doesn’t cause an outage. {{site.base_gateway}} provides a number of security capabilities to help customers secure the administration environment.

[Workspaces](/gateway/{{page.release}}/kong-manager/workspaces/) enable an organization to segment objects and admins into namespaces. The segmentation allows **teams** of admins sharing the same {{site.base_gateway}} cluster to adopt **roles** for interacting with specific objects. For example, one team (Team A) may be responsible for managing a particular service, whereas another team (Team B) may be responsible for managing another service. Teams should only have the roles they need to perform the administrative tasks within their specific workspaces.

{{site.base_gateway}} does all of this through [Role-Based Access Control (RBAC)](/gateway/{{page.release}}/kong-manager/auth/rbac/). All administrators can be given specific roles, whether you are using Kong Manager or the Admin API, which control and limit the scope of administrative privileges within specific workspaces.

User types in Kong Manager:
* [Admins](/gateway/{{page.release}}/kong-manager/auth/rbac/add-admin/): An admin belongs to a workspace and should have at least one role with a set of permissions.
If an admin is in a workspace *without* a role, they can't see or interact with anything.
Admins can manage entities inside workspaces, including users and their roles.

* [Super admins](/gateway/{{page.release}}/kong-manager/auth/super-admin/): Specialized admins with the ability to:
  * Manage all workspaces
  * Further customize permissions
  * Create entirely new roles
  * Invite or deactivate admins
  * Assign or revoke admin roles

* [RBAC users](/gateway/{{page.release}}/kong-manager/auth/rbac/add-user/):
RBAC users without administrator permissions.
They have access to manage {{site.base_gateway}}, but can't adjust teams, groups, or
user permissions.

Admins are assigned roles that have clearly defined permissions.
In Kong Manager, limiting permissions also restricts the visibility of the
application interface and navigation.
