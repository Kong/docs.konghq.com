---
title: Create a New Role with Custom Permissions
badge: enterprise
---
#### Prerequisites

* Authentication and RBAC are enabled, following the
[Getting Started](/gateway/{{page.kong_version}}/kong-production/running-kong/start-kong-securely/#prerequisites)
guide
* [Logged in as the Super Admin](/gateway/{{page.kong_version}}/kong-production/running-kong/start-kong-securely/#step-4)
or a user that has `/admins` and `/rbac` read and write access.

## Create a New Role with Custom Permissions

1. On the **Admins** page, to create a new **Role**, click the **Add Role** button at
the top right of the list of Roles.

2. On the **Add Role** form, name the **Role** according to the **Permissions** you want
to grant. Write a brief comment describing the **Permissions** of the **Role**.

3. Click the **Add Permissions** button and fill out the form. Add the endpoint
**Permissions** by marking the appropriate checkbox.

4. Click **Add Permission to Role** to see the **Permissions** listed on the form.

5. To forbid access to certain endpoints, click **Add Permission** again and use
the **negative** checkbox.

6. See the new **Role** appear on the **Admins** page

⚠️ **IMPORTANT**: Every **Admin** who needs access to Kong Manager will need at
least `read` access to the home "`/`" endpoint.

⚠️ **IMPORTANT**: A negative **Permission** will always take precedence over a
positive one.
