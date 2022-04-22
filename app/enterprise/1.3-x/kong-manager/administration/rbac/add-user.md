---
title: Create an RBAC User
book: admin_gui
toc: true
---

#### Admins vs. RBAC Users

|            | Admin API | Kong Manager |
|------------|-----------|--------------|
| Admins     |     ✔️     |       ✔️    |
| RBAC Users |     ✔️     |       X     |


An RBAC User has the ability to access the Kong Enterprise Admin API. The Permissions assigned to their Role will define the types of actions they can perform with various Admin API objects.

An [Admin](/enterprise/{{page.kong_version}}/kong-manager/security/#what-can-admins-do-in-kong-manager), like an RBAC User, has the ability to access the Kong Enterprise Admin API. The Admin also has the ability log in to Kong Manager. Like an RBAC User, an Admin’s Role will determine the types of actions it can perform—except that they will also have the ability to benefit from Kong Manager’s interface and visualizations.

If creating a *service account* for Kong Enterprise, e.g., for a machine as part of an automated process, then an RBAC User is adequate. 

If creating a *personal account* for Kong Enterprise, then Admin may be preferable since it also has access to Kong Manager.

#### Prerequisites

* Authentication and RBAC are enabled, following the 
[Getting Started](/enterprise/{{page.kong_version}}/getting-started/start-kong/#prerequisites) 
guide
* [Logged in as the Super Admin](/enterprise/{{page.kong_version}}/getting-started/start-kong/#step-4) 
or a user that has `/admins` and `/rbac` read and write access.

## How to Add an RBAC User in Kong Manager

1. From the dashboard, click the **Teams** tab in the top navigation menu.

2. On the **Teams** page, click the **RBAC Users** tab.

3. Using the dropdown menu, select which **Workspace** the new user has access to. 

    >Note: The **Default Workspace** is global, meaning the RBAC User with access to default has access to entities across all other Workspaces. This Workspace assignment is useful for administrative and auditing accounts, but not for members of specific teams. 

4. Click the **Add New User** button to the right of the dropdown menu to open the registration form.

5. In the **Add New User** registration form provide a Name, User Token, Comment, and Enablement

    The name of the RBAC User must be globally unique, even if two users are in different Workspaces, and it cannot have the same as an Admin account. 
    
    These naming conventions are important if using OIDC, LDAP, or another external method of identity and access management.
    
    The RBAC User account is enabled by default, if you want the RBAC User account to start in a disabled state and enable it later, uncheck the box.

6. Click the **Add User Roles** button in the **Role(s) per workspace** section. Select the Role (or Roles) desired for the new RBAC User.

    If the RBAC User has no Roles assigned, it will not have permission to access any objects. 
    
    An RBAC User’s Role assignments may be altered later if needed.
    
    The Roles can only belong to one Workspace, as selected in Step 3. 
    
    To provide an RBAC User with access to objects in multiple Workspaces, see Step 3.

7. Click **Create User** to complete the user registration.

    The page will automatically redirect back to the **Teams** page, where the new user is listed.
