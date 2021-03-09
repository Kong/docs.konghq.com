---
title: Manage Administrative Teams
---
<div class="alert alert-ee">
<img class="no-image-expand" src="/assets/images/icons/icn-enterprise-grey.svg" alt="Enterprise" /> This feature is only available with a {{site.ee_product_name}} subscription.
</div>

In this topic, you’ll learn how to manage and configure user authorization using workspaces and teams in {{site.ee_product_name}}.

If you are following the getting started workflow, make sure you have completed [Set Up Intelligent Load Balancing](/getting-started-guide/{{page.kong_version}}/load-balancing) before moving on.

## Overview of Workspaces and Teams

Many organizations have strict security requirements. For example, organizations need the ability to segregate the duties of an administrator to ensure that a mistake or malicious act by one administrator doesn’t cause an outage. {{site.ee_product_name}} provides a number of security capabilities to help customers secure the administration environment.

**Workspaces** enable an organization to segment objects and admins into namespaces. The segmentation allows teams of admins sharing the same {{site.ee_product_name}} cluster to adopt **roles** for interacting with specific objects. For example, one team (Team A) may be responsible for managing a particular service, whereas another team (Team B) may be responsible for managing another service. Teams should only have the roles they need to perform the administrative tasks within their specific workspaces.

{{site.ee_product_name}} does all of this through **Role-Based Access Control (RBAC)**. All administrators can be given specific roles, whether you are using Kong Manager or the Admin API, which control and limit the scope of administrative privileges within specific workspaces.

In this example, you’ll start by creating a simple workspace called “SecureWorkspace”. Then, you’ll create an administrator for that workspace, with rights to administer only the objects in the SecureWorkspace and nothing else.

## Securing your Kong Enterprise Installation

At a high level, securing {{site.ee_product_name}} administration is a two-step process:

1. Turn on RBAC.
2. Create a Workspace and an admin for segregated administration.

At this point in the Getting Started Guide, you have been interacting with your environment as the built-in Super Admin, `kong_admin`. The password for this `kong_admin` user was “seeded” during the installation process using the KONG_PASSWORD environment variable. Once RBAC is enabled, you will need to authenticate to the Kong Manager and the Kong Admin API using the proper credentials.

In the following sections, you will need the `kong_admin` account’s password in order to log in to {{site.ee_product_name}}, and the `kong_admin_uri` needs to be configured to avoid getting CORS errors.

## Turn on RBAC

To enable RBAC, you will need the initial KONG_PASSWORD that was used when you first installed {{site.ee_product_name}} and ran migrations. This is also the default password for the Super Admin, and will be required once RBAC is on.

{% navtabs %}
{% navtab UNIX-based system or Windows %}
1. Modify configuration settings below in your `kong.conf` file. Navigate to the file at `/etc/kong/kong.conf`:
    ```
    $ cd /etc/kong/
    ```
2. Copy the `kong.conf.default` file so you know you have a working copy to fall back to.

    ```
    $ cp kong.conf.default kong.conf
    ```

3. Now, edit the following settings in `kong.conf`:

    ```
    $ echo >> “enforce_rbac = off” >> /etc/kong/kong.conf
    $ echo >> “admin_gui_auth = basic-auth” >> /etc/kong.conf
    $ echo >> “admin_gui_session_conf = {"secret":"secret","storage":"kong","cookie_secure":false}”
    ```

    This will turn on RBAC, tell {{site.ee_product_name}} to use basic authentication (username/password), and tell the Sessions Plugin how to create a session cookie.

    The cookie is used for all subsequent requests to authenticate the user, until it expires. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended.

4. Restart {{site.ee_product_name}} and point to the new config file:

    ```
    $ kong restart -c /etc/kong/kong.conf
    ```
{% endnavtab %}
{% navtab Docker %}

If you have a Docker installation, run the following command to set the needed environment variables and reload the {{site.ee_product_name}} configuration.

**Note:** make sure to replace `<kong-container-id>` with the ID of your container.

```
$ echo "KONG_ENFORCE_RBAC=on KONG_ADMIN_GUI_AUTH=basic-auth KONG_ADMIN_GUI_SESSION_CONF='{\"secret\":\"secret\",\"storage\":\"kong\",\"cookie_secure\":false}' kong reload exit" | docker exec -i <kong-container-id>
```

This will turn on RBAC, tell {{site.ee_product_name}} to use basic authentication (username/password), and tell the Sessions Plugin how to create a session cookie.

The cookie is used for all subsequent requests to authenticate the user, until it expires. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended.

{% endnavtab %}
{% endnavtabs %}

Outside of this guide, you will likely want to modify these settings differently, depending on your installation. You can read more about these settings here: [Basic Auth for Kong Manager](/enterprise/latest/kong-manager/authentication/basic/).

## Create a Workspace
{% navtabs %}
{% navtab Using Kong Manager %}

#### Log into Kong Manager
1. Go to Kong Manager, or reload the page if you already have it open and you will see the following login screen.
2. Log into Kong Manager with the built-in Super Admin account, `kong_admin`, and its password.

    Remember, this is the initial KONG_PASSWORD you used when you ran migrations during installation.

3. If you have logged in successfully, then you can start administering your {{site.ee_product_name}} cluster.

    If this step did not work, and you know the credentials are correct, then something is likely wrong with your {{site.ee_product_name}} configuration. Double-check the settings, or, if the cause of the problem still isn’t clear, work with your {{site.ee_product_name}} account team and Kong support for assistance.

#### Create the Workspace
1. Access your Kong Manager instance.
2. On the Workspaces tab, click on **New Workspace**.
3. Create a Workspace named `SecureWorkspace` and select a color for the Workspace avatar.

    **Note:** Each Workspace name should be unique, regardless of letter case. For example, naming one Workspace “Payments” and another one “payments” will create two different workspaces that appear identical.

    **WARNING:** Do not give a Workspace the same name as any of these major routes in Kong Manager:

    |---------|-----------|--------------|---------------|
    | Admins  | APIs      | Certificates | Consumers     |
    | Plugins | Portal    | Routes       | Services      |
    | SNIs    | Upstreams | Vitals       | PermalinkStep |

4. Click **Create New Workspace**.
5. On the new Workspace, click **Teams**.
6. From the Teams page, click the **Roles** tab to view the default roles that come with {{site.ee_product_name}}.
7. Next to SecureWorkspace, click **View** to see its assigned roles.
8. There are different roles available for the SecureWorkspace. By default, each new workspace has the following roles and privileges:

    | Role                     | Description                                                                                  |
    |--------------------------|----------------------------------------------------------------------------------------------|
    | *workspace-admin*        | Can administer the objects in a workspace but can’t add new administrators to the workspace. |
    | *workspace-portal-admin* | Can manage the Developer Portal. |
    | *workspace-read-only*    | Can view anything in the workspace, but can’t make any changes. |
    | *workspace-super-admin*  | Can do anything inside the workspace. |

**Notes:**

* **Be careful:** granting access to the **default** workspace gives access to all workspaces in the organization.

* The **default** workspace only has three roles: *workspace-admin*, *workspace-super admin*, and *workspace-read-only*. Every other workspace will have the four roles mentioned above.

* You can also create custom roles by clicking on the **Add Role** button and specifying the endpoints that the administrator with the role will be able to interact with.
{% endnavtab %}
{% navtab Using the Admin API %}

Create a new Workspace called SecureWorkspace, substituting the `kong_admin` account’s password in place of `<super-user-token>`.

*Using cURL:*
```
$ curl -H Kong-Admin-Token:<super-user-token> -X POST http://<admin-hostname>:8001/workspaces \
--data 'name=SecureWorkspace'
```
*Or using HTTPie:*
```
$ http :8001/workspaces name=SecureWorkspace Kong-Admin-Token:<super-user-token>
```

**Note:** Each Workspace name should be unique, regardless of letter case. For example, naming one Workspace “Payments” and another one “payments” will create two different workspaces that appear identical.

**WARNING:**
* Granting access to the **default** workspace gives access to all workspaces in the organization.
* Do not give a Workspace the same name as any of these major routes in Kong Manager:

    |---------|-----------|--------------|---------------|
    | Admins  | APIs      | Certificates | Consumers     |
    | Plugins | Portal    | Routes       | Services      |
    | SNIs    | Upstreams | Vitals       | PermalinkStep |

If you are unable to log in with `kong_admin`'s token, and you know the credentials are correct, then something is likely wrong with your {{site.ee_product_name}} configuration. Double-check the settings, or, if the cause of the problem still isn’t clear, work with your {{site.ee_product_name}} account team and Kong support for assistance.

{% endnavtab %}
{% endnavtabs %}

## Create an Admin

Next, create an admin for the SecureWorkspace, granting them permissions to manage only that workspace.

{% navtabs %}
{% navtab Using Kong Manager %}
#### Invite a New Admin
<div class="alert alert-warning">
<strong>Note:</strong> If you also use the Admin API, once you've created this admin, you can find it under the <em>/admins</em> endpoint.</div>

1. From the **Teams** > **Admins** tab, click **Invite Admin**.
2. Enter the new administrator’s **Email** address, **Username**, and **Custom Id**.
3. Ensure that **Enable RBAC Token** is enabled.

    **Note:** This setting lets the admin use the Kong Admin API as well as Kong Manager. If you don’t want this user to access the Admin API, uncheck this box.

4. Click **Add/Edit Roles**.
5. In the Workspace Access dialog, select the **SecureWorkspace**.
6. Select the **workspace-admin** role, which makes this user the workspace administrator for the SecureWorkspace.

    When you are done adding roles, you are redirected back to the Invite Admin dialog.

    <div class="alert alert-warning">
    <strong>Important:</strong> Before you move on, make sure the <strong>Enable RBAC Token</strong> checkbox is checked. The RBAC token is what allows the new admin to send a token to the Admin API to configure the system programmatically.
    </div>

7. Click **Invite Admin** to send the invite.

    At this point in the getting started guide, you likely haven’t set up SMTP yet, so no email will be sent. Instead, you’ll later generate a registration link for the new administrator manually.

#### Register the Admin

1. Back on the **Teams** page, click **View** for the administrator you just created.
2. Click the **Generate registration link** button.

    Using this link, the new administrator can go to a web browser and paste it in to initiate his/her account and create an initial password. Again, normally, this would happen through SMTP, and the user would get this link through an email.

3. Click the **copy icon** to copy the registration link, then save it.
4. Email or SMS the registration link to the new administrator &mdash; or use it yourself to test the login in the following steps.
5. Open a different browser or an incognito tab in the current browser so your existing login session is ignored.
6. Enter the registration link you copied previously into the new browser to log in with the new administrator (secureworkspaceadmin).

    If the registration link has expired, you can generate a new one by logging in with your `kong_admin` administrator and generating a new link.

7. Enter a new password for your new administrator (save this in a secure place) and click on the **Register** button.

    If everything went well, you should see an “Account Setup Success” message.
{% endnavtab %}
{% navtab Using the Admin API %}

<div class="alert alert-warning">
<strong>Note:</strong> The following method refers to the <em>/users</em> endpoint and creates an Admin API user that won't be visible (or manageable) through Kong Manager. If you want to later administer the admin through Kong Manager, create it under the <a href="/enterprise/latest/admin-api/admins/reference/"><em>/admins</em> endpoint</a> instead.
</div>

1. Create a new user named `secureworkspaceadmin` with the RBAC token `secureadmintoken`.

    *Using cURL:*
    ```
    $ curl -H Kong-Admin-Token:<super-user-token> -X POST http://<admin-hostname>:8001/SecureWorkspace/rbac/users \
    --data 'name=secureworkspaceadmin' \
    --data 'user_token=secureadmintoken'
    ```
    *Or using HTTPie:*
    ```
    $ http :8001/SecureWorkspace/rbac/users name=secureworkspaceadmin user_token=secureadmintoken Kong-Admin-Token:<super-user-token>
    ```

2. Create a blank role in the workspace and name it `admin`.

    *Using cURL:*
    ```
    $ curl -H Kong-Admin-Token:<super-user-token> -X POST http://<admin-hostname>:8001/SecureWorkspace/rbac/roles \
    --data 'name=admin' \
    ```
    *Or using HTTPie:*
    ```
    http :8001/SecureWorkspace/rbac/roles/ name=admin Kong-Admin-Token:<super-user-token>
    ```

3. Give the `admin` role permissions to do everything on all endpoints in the workspace.

    *Using cURL:*
    ```
    $ curl -H Kong-Admin-Token:<super-user-token> -X POST http://<admin-hostname>:8001/SecureWorkspace/rbac/roles/admin/endpoints/ \
    --data 'endpoint=*'
    --data 'workspace=SecureWorkspace' \
    --data 'actions=*'
    ```
    *Or using HTTPie:*
    ```
    http :8001/secureworkspace/rbac/roles/admin/endpoints/ endpoint='*' workspace=SecureWorkspace actions='*' Kong-Admin-Token:<super-user-token>
    ```

4. Grant the `admin` role to `secureworkspaceadmin`.

    *Using cURL:*
    ```
    $ curl -H Kong-Admin-Token:<super-user-token> -X POST http://<admin-hostname>:8001/SecureWorkspace/rbac/users/secureworkspaceadmin/roles/ \
    --data 'role=admin'
    ```
    *Or using HTTPie:*
    ```
    http :8001/SecureWorkspace/rbac/users/secureworkspaceadmin/roles/ roles=admin Kong-Admin-Token:<super-user-token>
    ```

{% endnavtab %}
{% endnavtabs %}

## Verify the New Admin

{% navtabs %}
{% navtab Using Kong Manager %}

1. Click the **Login** button to be taken to a new screen to log in with your new administrator.
2. Enter the **Username** and **Password** of your new administrator and click **Login** again.

    Once you log in, you’ll notice that you can only see the SecureWorkspace.

3. You can also verify that this user’s administration rights are limited. As this user, if you open the Teams tab and try to add new administrators, Admin API users (RBAC users), Groups, or Roles, you won’t have the permissions to do so.

{% endnavtab %}
{% navtab Using the Admin API %}
1. Try to access the `default` workspace using `secureworkspaceadmin`'s user token.

    *Using cURL:*
    ```
    $ curl -H Kong-Admin-Token:secureadmintoken -X GET http://<admin-hostname>:8001/default/rbac/users
    ```
    *Or using HTTPie:*

    ```
    http :8001/default/rbac/users Kong-Admin-Token:secureadmintoken
    ```

    You should get a `403 Forbidden` error message:
    ```
    {
        “message”: “secureworkspaceadmin, you do not have permissions to read this resource”
    }
    ```
2. Then, try to access the same endpoint, but this time in the `SecureWorkspace`.

    *Using cURL:*
    ```
    $ curl -H Kong-Admin-Token:secureadmintoken -X GET http://<admin-hostname>:8001/SecureWorkspace/rbac/users
    ```
    *Or using HTTPie:*

    ```
    http :8001/default/rbac/users Kong-Admin-Token:secureadmintoken
    ```
    This time, you should get a `200 OK` success message and a list of users.

{% endnavtab %}
{% endnavtabs %}

That's it! You are now controlling access to {{site.ee_product_name}} administration with RBAC.

## Summary and next steps

In this topic, you:
* Enabled RBAC
* Created a workspace named `SecureWorkspace`.
* Created an admin named `secureworkspaceadmin` and granted them permissions to manage to everything in the `SecureWorkspace`.

Next, set up the [Kong Developer Portal](/getting-started-guide/{{page.kong_version}}/dev-portal).
