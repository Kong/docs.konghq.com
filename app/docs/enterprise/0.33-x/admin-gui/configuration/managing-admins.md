---
title: Managing Admins
book: admin_gui
chapter: 3
---
# Managing Admins for the Kong Admin GUI

In this section you will learn how to manage Kong Admins in the Kong Admin GUI. 

Prerequisites:
* You have enabled authentication, following the [Getting Started](/docs/enterprise/{{page.kong_version}}/admin-gui/configuration/getting-started/) guide.
* You have [enabled RBAC]()
* You have [setup the Super Admin RBAC Role]() or you are able to login with a user that has `/admins` and `/rbac` read/write access, with all associated endpoints for permission creation. We will refer to this user as the *Authorized Admin* in this guide.

## Create RBAC Roles for Your Admin

For every Admin that is using the Kong Admin GUI, they will need roles assigned to them based on which resources they can access.

Login as the Authorized Admin and click "Admins" in the sidebar. Next, click "Add Role". Fill out the form, and add the endpoint permissions. Name the role accordingly (e.g. "read-only", "read-services").

⚠️ **Important**: Every Admin that needs access to the Admin GUI will need at least `read` access to the home "`/`" endpoint.

## Create an Admin

Login to the Kong Admin GUI as the Super Admin. Click "Admins" in the sidebar. Click "Add Admin". Fill out the form with a username and associated Role.

## Grant Admin Access

Now that you have created an Admin and assigned them roles, you will need to give them access to login to the Admin GUI. If not using LDAP Auth Advanced, you will need to create Credentials via the API, as it is not currently supported in the Admin GUI.

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

* [Create a Basic Authentication Credential Username/Password](/plugins/basic-authentication/#create-a-credential)
* [Create a Key Authentication Credential Key](/plugins/key-authentication/#create-a-key)

Once a user has a credential
