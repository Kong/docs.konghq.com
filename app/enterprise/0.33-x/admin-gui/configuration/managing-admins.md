---
title: Managing Admins
book: admin_gui
chapter: 4
---
## Introduction

![Managing Admins in the Kong Admin GUI](https://konghq.com/wp-content/uploads/2018/07/admins1.png)

In this section you will learn how to manage Kong Admins in the Kong Admin GUI.

Prerequisites:
* You have enabled authentication, following the [Getting Started](/enterprise/{{page.kong_version}}/admin-gui/configuration/getting-started/) guide.
* You have [enabled RBAC](/enterprise/{{page.kong_version}}/rbac/overview/#enforcing-rbac)
* You have [setup the Super Admin RBAC Role](/enterprise/{{page.kong_version}}/rbac/examples/#bootstrapping-the-first-rbac-user-the-super-admin) or you are able to login with a user that has `/admins` and `/rbac` read/write access, with all associated endpoints for permission creation. We will refer to this user as the *Authorized Admin* in this guide.

## Create RBAC Roles for Your Admin

For every Admin that is using the Kong Admin GUI, they will need roles assigned to them based on which resources they can access.

Login as the Authorized Admin and click "Admins" in the sidebar. Next, click "Add Role". Fill out the form, and add the endpoint permissions. Name the role accordingly (e.g. "read-only", "read-services").

⚠️ **IMPORTANT**: Every Admin that needs access to the Admin GUI will need at least `read` access to the home "`/`" endpoint.

## Create an Admin

Login to the Kong Admin GUI as the Super Admin. Click "Admins" in the sidebar. Click "Add Admin". Fill out the form with a username and associated Role.

![Create an Admin in the Kong Admin GUI](https://konghq.com/wp-content/uploads/2018/07/admins2.png)

## Grant Admin Access

Now that you have created an Admin and assigned them roles, you will need to give them access to login to the Admin GUI. If not using the [LDAP Auth Advanced plugin](/enterprise/{{page.kong_versions}}/admin-gui/configuration/authentication/#ldap-authentication), you will need to create Credentials via the API, as it is not currently supported in the Admin GUI.

If you are using LDAP Auth Advanced Plugin, then you can skip credential creation and utilize the Consumer mapping feature, which allows you to map a LDAP user's `username` to a consumer's `username` or `custom_id`.

### Create Credentials

Admins are a type of Kong [Consumer](/0.13.x/admin-api/#consumer-object), and therefore can be given Kong Plugin Authentication Credentials. Find the value of your Kong configuration directive `admin_gui_auth`. You will need to create credentials based on that plugin. Ensure that you have the Admin entity data:

```bash
$ curl 'http://kong:8001/admins/<username>'
HTTP/1.1 200 OK

{
  "created_at": 1530911165000,
  "rbac_user": {
    "comment": "User generated on creation of Admin.",
    "user_token": "<RBAC_USER_TOKEN>",
    "id": "<RBAC_USER_ID>",
    "name": "user-<username>",
    "enabled": true,
    "created_at": 1530911165000
  },
  "id": "<CONSUMER_ID>",
  "status": 0,
  "username": "<username>",
  "type": 2
}
```

Now that you have the `<CONSUMER_ID>`, you can use this to create a credential with your associated `admin_gui_auth` plugin:

* [Create a Basic Authentication Credential Username/Password](/enterprise/{{page.kong_versions}}/admin-gui/configuration/authentication/#enable-authentication)
* [Create a Key Authentication Credential Key](/enterprise/{{page.kong_versions}}/admin-gui/configuration/authentication/#basic-authentication)

Once a user has a credential, they can use the credential to [log in](/enterprise/{{page.kong_versions}}/admin-gui/configuration/authentication/#logging-in).

Next: [Networking &rsaquo;]({{page.book.next}})
