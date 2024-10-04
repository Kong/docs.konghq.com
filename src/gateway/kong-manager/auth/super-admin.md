---
title: Create a Super Admin
badge: enterprise
---

If you seeded a super admin at the time of running
migrations by passing `KONG_PASSWORD`, you can log in to Kong Manager
with the `kong_admin` username.

Otherwise, if `enforce_rbac=off`, you can create your first
super admin within Kong Manager itself.

You can also use this guide to create additional super admins once
you have an account and `enforce_rbac=on`.

## Create a super admin

If you have a super admin account already and need to create additional super admins,
follow these steps:

1. Go to the **Teams** tab in Kong Manager.

2. Click the **Invite Admin** button and fill out the form.

3. Give the user the `super-admin` role in the `default` workspace.

4. Return to the Admins page, and in the **Invited** section,
click the email address of the user in order to view them.

5. Click **Generate Registration Link**.

6. Copy the link for later use after completing the account setup.

{:.important}
> **Important:** Kong Manager does not support entity-level RBAC. Run Kong
Manager on a node where `enforce_rbac` is set to `on` or `off`, but not `both`.


## Create your first super admin account post-installation

In the event that the default `kong_admin` super admin was not seeded
during the initial database preparation step as defined in
[How To Start {{site.base_gateway}} Securely](/gateway/{{page.release}}/production/access-control/start-securely/),
the following steps outline how to create and enable a new super admin post
installation.

1. Follow the instructions to [create a new super admin](#create-a-super-admin) user
account and generate a registration link.

2. Before the link generated above can be used, RBAC and GUI authentication must
be enabled. Follow the instructions for
[enabling basic authentication on Kong Manager](/gateway/{{page.release}}/kong-manager/auth/basic).

3. Paste the URL in your browser. You will be asked to create a password for
the newly defined super admin user.

4. Go to the Kong Manager homepage to login with the
new super admin credentials.
