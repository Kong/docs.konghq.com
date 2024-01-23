---
title: Access Control with Workspaces and Teams
badge: enterprise
---

In this topic, you’ll learn how to manage and configure user authorization using workspaces and teams in {{site.base_gateway}} with Kong Manager.

## Securing your Gateway installation

At a high level, securing {{site.base_gateway}} administration is a two-step process:

1. Turn on RBAC.
2. Create a workspace and an admin for segregated administration.

In the following sections, you will need the `kong_admin` account’s password to log in to {{site.base_gateway}}, and the `kong_admin_uri` needs to be configured to avoid getting CORS errors.

## Prerequisites

* RBAC is [enabled](/gateway/{{page.release}}/kong-manager/auth/rbac/enable/)
* You are [logged in as the super admin](/gateway/{{page.release}}/kong-manager/auth/super-admin/)
or a user that has `/admins` and `/rbac` read and write access.

## Create a workspace

For this example, start by creating a simple workspace called `SecureWorkspace`.

### Log into Kong Manager

1. Go to Kong Manager, or reload the page if you already have it open to see a login screen.
2. Log in to Kong Manager with the built-in Super Admin account, `kong_admin`, and its password.

    Remember, this is the initial `KONG_PASSWORD` you used when you ran migrations during installation.

3. If you have logged in successfully, then you can start administering your {{site.base_gateway}} cluster.

    If this step did not work, and you know the credentials are correct, then something is likely wrong with your {{site.base_gateway}} configuration. Double-check the settings. If the cause of the problem still isn’t clear, work with your {{site.konnect_product_name}} account team and [Kong Support](https://support.konghq.com/) for assistance.

### Create the workspace

1. Access your Kong Manager instance.
2. On the workspaces tab, click on **New Workspace**.
3. Create a workspace named `SecureWorkspace` and select a color or image for the workspace avatar.

    {:.important}
    > Workspace names are **case sensitive** ("Payments" and "payments" are not equal), so it is recommended you give your workspaces unique names regardless of letter case to prevent confusion.
    >
    > <br>
    > Additionally, do not give a workspace the same name as any of these major routes in Kong Manager:
    >
    |---------|-----------|--------------|---------------|
    | Admins  | APIs      | Certificates | Consumers     |
    | Plugins | Portal    | Routes       | Services      |
    | SNIs    | Upstreams | Vitals       | PermalinkStep |

4. Click **Create New Workspace** to open a new workspace dashboard.
5. Click the **Teams** tab.
6. From the Teams page, click the **Roles** tab.
7. Select `SecureWorkspace` to view the default roles that come with {{site.base_gateway}}.

    By default, each new workspace has the following roles and privileges:

    | Role                     | Description                                                                                  |
    |--------------------------|----------------------------------------------------------------------------------------------|
    | *workspace-admin*        | Full access to all endpoints in the workspace except the RBAC Admin API. |
    | *workspace-portal-admin* | Full access to Dev Portal related endpoints in the workspace. |
    | *workspace-read-only*    | Read access to all endpoints in the workspace. |
    | *workspace-super-admin*  | Full access to all endpoints in the workspace. |

**Notes:**

* **Caution** Granting access to the **default** workspace gives access to all workspaces in the organization.

* The **default** workspace only has three roles: *workspace-admin*, *workspace-super-admin*, and *workspace-read-only*. Every other workspace will have the four roles mentioned above.

* You can also create custom roles by clicking on the **Add Role** button and specifying the endpoints that the administrator with the role will be able to interact with.

## Create an admin

Next, create an admin for the SecureWorkspace, granting them permissions to manage only that workspace.

### Invite a new admin

1. From the **Teams** > **Admins** tab, click **Invite Admin**.
2. Enter the new administrator’s **Email address** , **Username**, and **Custom Id**.
3. Ensure that **Enable RBAC Token** is enabled.

    This setting allows the new admin to use the Admin API as well as Kong Manager.

4. Click **Add/Edit Roles**.
5. In the Workspace Access dialog, select the **SecureWorkspace**.
6. Select the **workspace-admin** role, which makes this user the workspace administrator for the SecureWorkspace.

    When you are done adding roles, you are redirected back to the **Invite Admin** dialog.

    {:.important}
    > **Important:** Before you proceed, ensure the **Enable RBAC Token** checkbox is checked. The RBAC token is what allows the new admin to use the Admin API to configure the system programmatically.

7. Click **Invite Admin** to send the invite.

    If you have [SMTP](/gateway/{{page.release}}/kong-manager/configuring-to-send-email/) set up, Kong Manager sends an email with a registration link.

    If you don't have SMTP enabled, the following instructions guide you to generate a registration link manually.

### Register the admin manually

1. Back on the **Teams** page, click the administrator you just created.
2. Click the **Generate registration link** button.

    Using this link, the new administrator can go to a web browser and paste it in to initiate his/her account and create an initial password. Again, normally, this would happen through SMTP, and the user would get this link through an email.

3. Click the **copy icon** to copy the registration link, then save it.

4. Send the registration link to the new administrator, or use it yourself to test the login in the following steps.

5. Open a different browser or an incognito tab in the current browser.
6. Enter the registration link you copied previously into the browser to log in with the new administrator.

    If the registration link has expired, you can generate a new one by logging in with your `kong_admin` administrator and generating a new link.

7. Enter a new password for your new administrator (save this in a secure place) and click the **Register** button.

    If everything went well, you should see an “Account Setup Success” message.

## Verify the new admin

1. Click the **Login** button to be taken to a new screen to log in with your new administrator.
2. Enter the **Username** and **Password** of your new administrator and click **Login** again.

    Once you log in, you’ll notice that you can only see the SecureWorkspace.

3. You can also verify that this user’s administration rights are limited. As this user, if you open the Teams tab and try to add new administrators, Admin API users (RBAC users), groups, or roles, you won’t have the permissions to do so.

You are now controlling access to {{site.base_gateway}} administration with RBAC.
