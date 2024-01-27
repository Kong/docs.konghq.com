---
title: Create an RBAC User
badge: enterprise
---

## Admins vs. RBAC users

|            | Admin API | Kong Manager |
|------------|-----------|--------------|
| Admins     |     ✔️     |       ✔️      |
| RBAC users |     ✔️     |       X      |


An RBAC user has the ability to access the {{site.base_gateway}} Admin API. The permissions assigned to their role will define the types of actions they can perform with various Admin API objects.

An [admin](/gateway/{{page.release}}/kong-manager/auth/), like an RBAC user, has the ability to access the {{site.base_gateway}} Admin API. The admin also has the ability log in to Kong Manager. Like an RBAC user, an admin’s role determines the types of actions it can perform, except that they also have the ability to benefit from Kong Manager’s interface and visualizations.

If creating a *service account* for {{site.base_gateway}}, e.g., for a machine as part of an automated process, then an RBAC User is adequate.

If creating a *personal account* for {{site.base_gateway}}, then admin may be preferable since it also has access to Kong Manager.

## Prerequisites

* Authentication and RBAC are [enabled](/gateway/{{page.release}}/kong-manager/auth/rbac/enable/)
* You have [super admin permissions](/gateway/{{page.release}}/kong-manager/auth/super-admin/)
or a user that has `/admins` and `/rbac` read and write access

## Add an RBAC user in Kong Manager

1. From the dashboard, click the **Teams** tab.

2. On the **Teams** page, click the **RBAC Users** tab.

3. Using the dropdown menu, select which **Workspace** the new user has access to.

    {:.note}
    > **Note:** The **Default Workspace** is global, meaning the RBAC user with access to default has access to entities across all other Workspaces. This workspace assignment is useful for administrative and auditing accounts, but not for members of specific teams.

4. Click the **Add New User** button to open the registration form.

5. Fill out the **Add New User** registration form.

    * The name of the RBAC user must be globally unique, even if two users are in different workspaces, and it can't have the same name as an admin account.
        These naming conventions are important if using OIDC, LDAP, or another external method of identity and access management.
    * The RBAC user account is enabled by default. If you want the RBAC user account to start in a disabled state and enable it later, uncheck the **Enabled** box.

6. Click the **Add/Edit Roles** button. Select the role (or roles) desired for the new RBAC User.

    * If the RBAC user has no roles assigned, it will not have permission to access any objects.
    * An RBAC user’s role assignments may be altered later if needed.
    * The roles can only belong to one workspace, as selected in Step 3.
    * To provide an RBAC user with access to objects in multiple workspaces, see Step 3.

7. Click **Create User** to complete the user registration.

    The page will automatically redirect back to the **Teams** page, where the new user is listed.
