---
title: Create a New Role with Custom Permissions
book: admin_gui
---
#### Prerequisites

* Authentication and RBAC are enabled, following the
[Getting Started](/enterprise/{{page.kong_version}}/start-kong-securely/#prerequisites)
guide
* [Logged in as the Super Admin](/enterprise/{{page.kong_version}}/start-kong-securely/#step-4)
or a user that has `/admins` and `/rbac` read and write access.

## Create a New Role with Custom Permissions

1. On the **Admins** page, to create a new **Role**, click the **Add Role** button at
the top right of the list of Roles.

2. On the **Add Role** form, name the **Role** according to the **Permissions** you want
to grant. Write a brief comment describing the **Permissions** of the **Role**.

    ![New Role naming](https://konghq.com/wp-content/uploads/2018/11/km-new-role.png)

3. Click the **Add Permissions** button and fill out the form. Add the endpoint
**Permissions** by marking the appropriate checkbox.

    ![New Role permissions](https://konghq.com/wp-content/uploads/2018/11/km-perms.png)

4. Click **Add Permission to Role** to see the **Permissions** listed on the form.

    ![New Role permissions list](https://konghq.com/wp-content/uploads/2018/11/km-perms-list.png)

5. To forbid access to certain endpoints, click **Add Permission** again and use
the **negative** checkbox.

    ![Negative permissions](https://konghq.com/wp-content/uploads/2018/11/km-negative-perms.png)

6. See the new **Role** appear on the **Admins** page

    ![Roles list](https://konghq.com/wp-content/uploads/2018/11/km-roles-list.png)

⚠️ **IMPORTANT**: Every **Admin** who needs access to Kong Manager will need at
least `read` access to the home "`/`" endpoint.

⚠️ **IMPORTANT**: A negative **Permission** will always take precedence over a
positive one.

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2019/02/role-creation-ent-34.mov" type="video/mp4">
 Your browser does not support the video tag.
</video>
