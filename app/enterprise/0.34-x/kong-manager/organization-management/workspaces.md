---
title: Workspaces
book: admin_gui
chapter: 5
---

## How to Create a New Workspace

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2019/02/new-workspace-ent-34.mov" type="video/mp4">
 Your browser does not support the video tag.
</video>

1. Log in as the Super Admin. On the "Workspaces" page, click the "New Workspace" button at the top right to see the "Create Workspace" form.

    ![New Workspace Form](https://konghq.com/wp-content/uploads/2018/11/km-new-workspace.png)

2. Name the new Workspace.
    
    ![Name the New Workspace](https://konghq.com/wp-content/uploads/2018/11/km-name-ws.png)

    ⚠️ **WARNING**: Each Workspace name should be unique, regardless of letter 
    case. For example, naming one Workspace "Payments" and another one 
    "payments" will create two different workspaces that look identical.

    ⚠️ **WARNING**: Do not name Workspaces the same as these major routes in Kong 
    Manager:

    ```
    • Admins
    • APIs
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

3. Select a color or avatar to make each Workspace easier to distinguish, or accept the default color. 

    ![Select Workspace Color](https://konghq.com/wp-content/uploads/2018/11/km-color-ws.png)

4. Click the "Create New Workspace" button. Upon creation, the application will navigate to the new Workspace's "Dashboard" page.

    ![New Dashboard](https://konghq.com/wp-content/uploads/2018/11/km-new-dashboard.png)

5. On the left sidebar, click the "Admins" link in the "Security" section. If 
the sidebar is collapsed, hover over the security badge icon at the bottom and 
click the "Admins" link. 

    ![Admins Hover Over](https://konghq.com/wp-content/uploads/2018/11/admins-section.png)

6. The "Admins" page displays a list of current Admins and Roles. Four default Roles specific to the new Workspace are already visible, and new Roles specific to the Workspace can be assigned from this page. 

    ![New Workspace Admins](https://konghq.com/wp-content/uploads/2018/11/km-ws-admins.png)

## How to Update or Delete a Workspace

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2019/02/delete-ws-ent-34.mov" type="video/mp4">
 Your browser does not support the video tag.
</video>

⚠️ **IMPORTANT**: In order to delete a Workspace, everything inside the 
Workspace must be deleted first. This includes default Roles on the "Admins" 
page.

1. Within the Workspace, navigate to the "Dashboard" page.

    ![Workspace Dashboard](https://konghq.com/wp-content/uploads/2018/11/km-dashboard.png)

2. At the top right, click the "Settings" button.

3. Edit or delete the Workspace.

## Navigating across Workspaces in Kong Manager

To navigate between Workspaces, from the "Overview" page, click on any 
Workspace displayed beneath the Vitals chart. The list of Workspaces may be 
rendered as cards or a table, depending on preference.

![Workspace List](https://konghq.com/wp-content/uploads/2018/11/km-ws-list.png)

If a Role does not have permission to access entire endpoints, the user 
assigned to the Role will not be able to see the related navigation links.

For more information about Admins and Roles, see [RBAC and Permissions](/enterprise/{{page.kong_version}}/kong-manager/organization-management/rbac-and-perms). For 
information about how RBAC applies to specific Workspaces, see 
[RBAC in Workspaces](/enterprise/{{page.kong_version}}/kong-manager/organization-management/rbac-in-workspaces)

Next: [RBAC and Permissions &rsaquo;]({{page.book.next}})
