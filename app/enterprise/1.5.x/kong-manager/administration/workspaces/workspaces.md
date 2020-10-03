---
title: Workspaces in Kong Manager
book: admin_gui
---

**Workspaces** enable an organization to segment traffic so that
teams of **Admins** sharing the same Kong cluster are only able to
interact with entities from their groups. Within a **Workspace**,
it is possible to invite **Admins** to a particular team and to
enforce **RBAC** with **Roles** and **Permissions** that further
delimit the types of actions and entities available to an **Admin**.

## Default Workspace

When the first **Super Admin** logs in, they begin in the **Workspace**
named **default**. From here, they may invite **Admins** who are
intended to be able to manage all other **Workspaces**, as well as
the **Workspaces** themselves.

## Navigating across Workspaces in Kong Manager

To navigate between Workspaces from the **Overview** page, click on any
Workspace displayed beneath the **Vitals** chart.

The list of **Workspaces** may be rendered as cards or a table,
depending on preference.

![Workspace List](https://doc-assets.konghq.com/1.3/manager/kong-manager-workspaces-grid.png)


## Creating New Workspaces

1. Log in as the **Super Admin**. On the **Workspaces** page, click the **New Workspace**
button at the top right to see the **Create Workspace** form. Name and choose a
color / icon for the new Workspace.

    ![New Workspace Form](https://doc-assets.konghq.com/1.3/manager/workspaces/01-create-new-workspace.png)

    ⚠️ **WARNING**: Do not name Workspaces the same as these major routes in Kong
    Manager:

    ```
    • Admins
    • Certificates
    • Consumers
    • Plugins
    • Portal
    • Routes
    • Services
    • SNIs
    • Upstreams
    • Vitals
    ```

4. Click the "Create New Workspace" button. Upon creation, the application will
navigate to the new Workspace's dashboard.

    ![New Dashboard](https://doc-assets.konghq.com/1.3/manager/workspaces/02-workspace-dashboard.png)


## Delete or Edit a Workspace

⚠️ **IMPORTANT**: In order to delete a Workspace, everything inside the
Workspace must be deleted first. This includes default Roles on the "Admins"
page.

1. Within the Workspace, navigate to the "Dashboard" page.

    ![Workspace Dashboard](https://doc-assets.konghq.com/1.3/manager/workspaces/02-workspace-dashboard.png)

2. At the top right, click the "Settings" button.

3. Edit or delete the Workspace.


## Workspace Access

If a **Role** does not have permission to access entire endpoints within
a **Workspace**, the **Admin** assigned to that **Role** will not be
able to see the related navigation links.

For more information about **Admins** and **Roles**, see
[RBAC in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/administration/rbac/).
