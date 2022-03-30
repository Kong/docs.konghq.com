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

## Edit a workspace

1. In the workspace you want to edit, navigate to the **Dashboard** page.

1. Near the top right, click the **Settings** button. This button takes you to the **Edit Workspace** page.

1. Here, you can edit the workspace name, avatar, and avatar background color.

1. Click **Update Workspace** to save.

## Delete a workspace

### Wipe workspace data
To delete a workspace, *all data* must first be deleted from the workspace.
Choose one of the following methods.

{% navtabs %}
{% navtab Kong Manager %}
Using Kong Manager, complete the following:

1.  Manually delete all files via **Dev Portal** > **Editor**. You cannot delete folders at this time, but deleting
all files from a folder will remove the folder.
1. Turn off the Dev Portal. Go to Dev Portal **Settings** > **Advanced** > **Turn Off**.
1. Remove all roles from the workspace:
     1. Go to **Teams** in the top navigation.
     1. Navigate to the **Roles** tab.
     1. Click **View** on the workspace you want to delete.
     1. Go to each role entry and click **Edit**.
     1. In the entry detail page, click **Delete Role**. A confirmation modal will appear. Click **Delete Role** again.

{% endnavtab %}
{% navtab Admin API %}

1. Delete all Dev Portal files associated with the workspace:

    ```bash
    curl -i -X DELETE http://localhost:8001/{WORKSPACE_NAME}/files
    ```

1. Turn off the Dev Portal for the workspace:

   ```bash
   curl -X PATCH http://localhost:8001/workspaces/{WORKSPACE_NAME}  \
    --data "config.portal=false"
   ```

1. [Delete each role](/enterprise/{{page.kong_version}}/admin-api/rbac/reference/#delete-a-role)
from the workspace:

    ```bash
    curl -i -X DELETE http://localhost:8001/{WORKSPACE_NAME}/rbac/roles/{ROLE_NAME|ROLE_ID}
    ```
{% endnavtab %}
{% navtab Portal CLI %}

1. Delete all Dev Portal files associated with the workspace:

    ```sh
    portal wipe WORKSPACE_NAME
    ```

2. Turn off the Dev Portal for the workspace:

    ```sh
    portal disable WORKSPACE_NAME
    ```

3. Delete each role from the workspace. You can't complete this step using the
Portal CLI, so switch to either the *Kong Manager* or *Admin API* tab and complete
step 3.

{% endnavtab %}
{% endnavtabs %}

### Delete a clean workspace

If your workspace is clean, you can delete it using the Kong Manager GUI or the
Kong Admin API. If not, see the previous section to [wipe workspace data](#wipe-workspace-data).

{% navtabs %}
{% navtab Kong Manager %}

1. In the workspace you want to delete, navigate to the **Dashboard** page.

1. Near the top right, click the **Settings** button. This button takes you to the **Edit Workspace** page.

1. Click **Delete** in the bottom right corner.

    The deletion will fail if you have any data in your workspace.

{% endnavtab %}
{% navtab Admin API %}

Send a `DELETE` request to the Kong Admin API:

```sh
curl -i -X DELETE http://localhost/workspaces/{WORKSPACE_NAME|WORKSPACE_ID}
```

The deletion will fail if you have any data in your workspace.

If it is successful, you should see the following response:

```
HTTP 204 No Content
```

{% endnavtab %}
{% endnavtabs %}

## Workspace Access

If a **Role** does not have permission to access entire endpoints within
a **Workspace**, the **Admin** assigned to that **Role** will not be
able to see the related navigation links.

For more information about **Admins** and **Roles**, see
[RBAC in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/administration/rbac/).
