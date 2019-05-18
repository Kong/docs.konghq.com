---
title: How to Create a New Workspace in Kong Manager
book: admin_gui
---

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