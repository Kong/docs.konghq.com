---
title: Workspaces and Teams
badge: enterprise
---

In this topic, you’ll learn how to manage and configure user authorization using workspaces and teams in {{site.base_gateway}}.

If you are following the getting started workflow, make sure you have completed [Set Up Intelligent Load Balancing](/gateway/{{page.kong_version}}/get-started/comprehensive/load-balancing) before moving on.

## Overview of workspaces and Teams

Many organizations have strict security requirements. For example, organizations need the ability to segregate the duties of an administrator to ensure that a mistake or malicious act by one administrator doesn’t cause an outage. {{site.base_gateway}} provides a number of security capabilities to help customers secure the administration environment.

**Workspaces** enable an organization to segment objects and admins into namespaces. The segmentation allows teams of admins sharing the same {{site.base_gateway}} cluster to adopt **roles** for interacting with specific objects. For example, one team (Team A) may be responsible for managing a particular service, whereas another team (Team B) may be responsible for managing another service. Teams should only have the roles they need to perform the administrative tasks within their specific workspaces.

{{site.base_gateway}} does all of this through **Role-Based Access Control (RBAC)**. All administrators can be given specific roles, whether you are using Kong Manager or the Admin API, which control and limit the scope of administrative privileges within specific workspaces.

In this example, you’ll start by creating a simple workspace called `SecureWorkspace`. Then, you’ll create an administrator for that workspace, with rights to administer only the objects in the SecureWorkspace and nothing else.

>**Note:** The steps in this topic cannot be performed using declarative
configuration.

## Securing your Gateway Installation

At a high level, securing {{site.base_gateway}} administration is a two-step process:

1. Turn on RBAC.
2. Create a workspace and an admin for segregated administration.

At this point in the Getting Started Guide, you have been interacting with your environment as the built-in Super Admin, `kong_admin`. The password for this `kong_admin` user was “seeded” during the installation process using the KONG_PASSWORD environment variable. After RBAC is enabled, you must authenticate to the Admin API using the proper credentials.

In the following sections, you will need the `kong_admin` account’s password to log in to {{site.base_gateway}}, and the `kong_admin_uri` needs to be configured to avoid getting CORS errors.

## Turn on RBAC

{% include_cached /md/enterprise/turn-on-rbac.md %}

## Create a workspace

Create a new workspace called SecureWorkspace, substituting the `kong_admin`
account’s password in place of `<super-user-token>`:

```sh
curl -X POST http://localhost:8001/workspaces \
  -H Kong-Admin-Token:<super-user-token> \
  --data 'name=SecureWorkspace'
```

**Note:** Each workspace name should be unique, regardless of letter case. For example, naming one workspace “Payments” and another one “payments” will create two different workspaces that appear identical.

**WARNING:**
* Granting access to the **default** workspace gives access to all workspaces in the organization.
* Do not give a workspace the same name as any of these major routes in Kong Manager:

    |---------|-----------|--------------|---------------|
    | Admins  | APIs      | Certificates | Consumers     |
    | Plugins | Portal    | Routes       | Services      |
    | SNIs    | Upstreams | Vitals       | PermalinkStep |

If you are unable to log in with `kong_admin`'s token, and you know the credentials are correct, then something is likely wrong with your {{site.base_gateway}} configuration. Double-check the settings, or, if the cause of the problem still isn’t clear, work with your {{site.konnect_product_name}} account team and Kong support for assistance.

## Create an Admin

Next, create an admin for the SecureWorkspace, granting them permissions to manage only that workspace.

<div class="alert alert-warning">
<strong>Note:</strong> The following method refers to the <em>/users</em> endpoint and creates an Admin API user that won't be visible (or manageable) through Kong Manager. If you want to later administer the admin through Kong Manager, create it under the <a href="/gateway/{{page.kong_version}}/admin-api/admins/reference/"><em>/admins</em> endpoint</a> instead.
</div>

Create a new user named `secureworkspaceadmin` with the RBAC token
`secureadmintoken`:


```sh
curl -X POST http://localhost:8001/SecureWorkspace/rbac/users \
  -H Kong-Admin-Token:<super-user-token> \
  --data 'name=secureworkspaceadmin' \
  --data 'user_token=secureadmintoken'
```

Create a blank role in the workspace and name it `admin`:

```sh
curl -X POST http://localhost:8001/SecureWorkspace/rbac/roles \
  -H Kong-Admin-Token:<super-user-token> \
  --data 'name=admin' \
```

Give the `admin` role permissions to do everything on all endpoints in the
workspace:

```sh
curl -X POST http://localhost:8001/SecureWorkspace/rbac/roles/admin/endpoints/ \
  -H Kong-Admin-Token:<super-user-token> \
  --data 'endpoint=*'
  --data 'workspace=SecureWorkspace' \
  --data 'actions=*'
```

Grant the `admin` role to `secureworkspaceadmin`:

```sh
curl -X POST http://localhost:8001/SecureWorkspace/rbac/users/secureworkspaceadmin/roles/ \
  -H Kong-Admin-Token:<super-user-token> \
  --data 'role=admin'
```

## Verify the New Admin

1. Try to access the `default` workspace using `secureworkspaceadmin`'s user token.

    ```sh
    curl -H Kong-Admin-Token:secureadmintoken -X GET http://localhost:8001/default/rbac/users
    ```

    You should get a `403 Forbidden` error message:
    ```
    {
        “message”: “secureworkspaceadmin, you do not have permissions to read this resource”
    }
    ```
2. Then, try to access the same endpoint, but this time in the `SecureWorkspace`.

    *Using cURL:*
    ```sh
    curl -H Kong-Admin-Token:secureadmintoken -X GET http://localhost:8001/SecureWorkspace/rbac/users
    ```

    This time, you should get a `200 OK` success message and a list of users.


You are now controlling access to {{site.base_gateway}} administration with RBAC.

## Summary and next steps

In this topic, you:

* Enabled RBAC.
* Created a workspace named `SecureWorkspace`.
* Created an admin named `secureworkspaceadmin` and granted them permissions to manage to everything in the `SecureWorkspace`.

Next, set up the [Dev Portal](/gateway/{{page.kong_version}}/get-started/comprehensive/dev-portal).
