---
title: Configure Workspaces in Kong Manager
badge: enterprise
---

Workspaces enable an organization to segment traffic so that
teams of admins sharing the same Kong cluster are only able to
interact with entities from their groups. Within a workspace,
it is possible to invite admins to a particular team and to
enforce RBAC with roles and permissions that further
delimit the types of actions and entities available to an admin.

## Prerequisites

* Authentication and RBAC are [enabled](/gateway/{{page.kong_version}}/kong-manager/auth/rbac/)
* You are logged into Kong Manager as a [super admin](/gateway/{{page.kong_version}}/kong-manager/auth/super-admin/)
or a user that has `/admins` and `/rbac` read and write access

## Default workspace

When the first Super Admin logs in, they begin in the workspace
named **default**. From here, they may invite admins to manage the default or
any other workspaces.

## Navigating across workspaces in Kong Manager

To navigate between workspaces from the **Overview** page, click on any
workspace displayed beneath the **Vitals** chart.

The list of workspaces may be rendered as cards or a table,
depending on preference.

## Create a Workspace

This guide describes how to create workspaces in Kong
Manager. You can also use the Admin API [`/workspaces/` route](/gateway/{{page.kong_version}}/admin-api/workspaces/reference/#add-workspace) to create a workspace.

1. Log in as the **Super Admin**. On the **Workspaces** page, click the **New Workspace**
button to see the **Create Workspace** form. Name and choose a
color / icon for the new Workspace.

    Each workspace name should be unique,
    regardless of letter case. For example, naming one
    workspace "Payments" and another one "payments" will
    create two different workspaces that appear identical.

    Do not name workspaces the same as these major API names (paths)
    in Admin API:

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

2. Click the **Create New Workspace** button. Upon creation, the application will
navigate to the new Workspace's dashboard.

## Edit a workspace

1. In the workspace you want to edit, navigate to the **Dashboard** page.

1. Click the **Settings** button. This button takes you to the **Edit Workspace** page.

1. Here, you can edit the workspace avatar and avatar background color.

1. Click **Update Workspace** to save.

## Delete a workspace

To delete a workspace, *all data* must first be deleted from the workspace.
Choose one of the following methods.

{% navtabs %}
{% navtab Kong Manager %}
Using Kong Manager, complete the following:

1. Go to **Workspaces** and select the workspace you want to delete.

1. Click **Settings** and then **Delete**.

1. In the **Delete Workspace** dialog, enter the name of the workspace, select **Confirm: delete all associated resources**, and then click **Delete**. 

This will automatically delete all entities (teams and roles) associated with the workspace as well as the workspace itself.

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

1. [Delete each role](/gateway/{{page.kong_version}}/admin-api/rbac/reference/#delete-a-role)
from the workspace:

    ```bash
    curl -i -X DELETE http://localhost:8001/{WORKSPACE_NAME}/rbac/roles/{ROLE_NAME|ROLE_ID}
    ```

1. Send a `DELETE` request to the Kong Admin API:

    ```sh
    curl -i -X DELETE http://localhost/workspaces/{WORKSPACE_NAME|WORKSPACE_ID}
    ```

    The deletion will fail if you have any data in your workspace.

    If it is successful, you should see the following response:

    ```
    HTTP 204 No Content
    ```
{% endnavtab %}
{% navtab Portal CLI %}

1. Delete all Dev Portal files associated with the workspace:

    ```sh
    portal wipe WORKSPACE_NAME
    ```

1. Turn off the Dev Portal for the workspace:

    ```sh
    portal disable WORKSPACE_NAME
    ```

1. Delete each role from the workspace. You can't complete this step using the
Portal CLI, so switch to the *Admin API* tab and complete
step 3.

1. Delete the workspace. You can't complete this step using the
Portal CLI, so switch to either the *Kong Manager* or *Admin API* tab and complete
step 4.

{% endnavtab %}
{% endnavtabs %}

## Workspace Access

If a role does not have permission to access entire endpoints within
a workspace, the admin assigned to that role will not be
able to see the related navigation links.

To set up access:
1. Open Kong Manager.
2. Click the **Admins** link in the
**Security** section.

  If the sidebar is collapsed, hover over
  the **security badge icon** and click
  **Admins**.

The Admins page displays a list of current admins and
roles. Four default roles specific to the new
workspace are already visible, and new roles specific
to the workspace can be assigned from this page.

For more information about admins and roles, see
[RBAC in Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth/rbac/).
