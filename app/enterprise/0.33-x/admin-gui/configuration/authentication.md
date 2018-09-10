---
title: Authenticating the Admin GUI
book: admin_gui
chapter: 3
---

# {{page.title}}

- [Enable Authentication](#enable-authentication)
- [Add a Credential](#add-a-credential)
- [Example configurations](#example-configurations)
  - [Key Authentication](#key-authentication)
  - [LDAP Authentication](#ldap-authentication)
  - [Basic Authentication](#basic-authentication)
- [Logging In](#logging-in)
- [Logging Out](#logging-out)
- [How Authentication is Stored in Local Storage](#how-authentication-is-stored-in-local-storage)

> Before you begin, make sure you have gone through the 
[Getting Started with the Admin GUI](https://getkong.org/enterprise/{{page.kong_version}}/admin-gui/configuration/getting-started)

## Enable Authentication

First, we will configure the Admin GUI using [Key Authentication](https://getkong.org/plugins/key-authentication). 
First, we should add an Administrator entity using the Admin API:

```bash
curl -X POST http://kong:8001/admins/    \
    --data "username=<USERNAME>"         \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created

{
  "rbac_user": {
    "comment": "User generated on creation of Admin.",
    "user_token": "a3cebf9e-820d-4543-b760-2b6986e3bb9d",
    "id": "1e24c54d-e575-4910-8a58-4d5f7203be08",
    "name": "user-<USERNAME>-<CUSTOM_ID>",
    "created_at": 1530577554000,
    "enabled": true
  },
  "consumer": {
    "custom_id": "<CUSTOM_ID>",
    "created_at": 1530577554000,
    "id": "1f8c8ce4-7625-4fa4-8904-6a2a507ffa93",
    "status": 0,
    "username": "<USERNAME>",
    "type": 2
  }
}
```

Save the generated `user_token` (`a3cebf9e-820d-4543-b760-2b6986e3bb9d` in the
example above) for use later. It must be sent in the `Kong-Admin-Token` header
when RBAC is enabled if using a client (e.g. cURL or HTTPie) other than the
Admin GUI.

After you have created an admin, you can provision a credential Key for this
admin to use to login to the Admin GUI:

```bash
curl -X POST http://kong:8001/consumers/{consumer}/key-auth -d ''
HTTP/1.1 201 Created

{
    "consumer_id": "876bf719-8f18-4ce5-cc9f-5b5af6c36007",
    "created_at": 1443371053000,
    "id": "62a7d3b7-b995-49f9-c9c8-bac4d781fb59",
    "key": "62eb165c070a41d5c1b58d9d3d725ca1"
}
```

Save this `"key": "62eb165c070a41d5c1b58d9d3d725ca1"` for use later. Note that this key is separate and distinct from the admin's RBAC token. 

When the Admin was created earlier it also created an RBAC user. This RBAC user now
needs to have the RBAC Super Admin role added to it. You might need to create
an RBAC user to associate to this Admin. To add the Super Admin, see 
"[Bootstrapping the first RBAC user - the Super Admin](/enterprise/{{page.kong_version}}/rbac/examples/#bootstrapping-the-first-rbac-user-the-super-admin)". 

```
curl -X POST http://kong:8001/rbac/users/{username}/roles/super-admin
```

Now that you have an Admin with an associated login Key and an RBAC Super-Admin, 
update the following in your Kong Configuration, then restart Kong.

```
admin_gui_auth = key-auth
enforce_rbac = on
```

The Admin GUI is now aware that authentication is enabled and will restrict access so that
only the Super Admin can login. Browse to the Admin GUI and you will be prompted with a 
[Login](#logging-in) form. Enter in the key saved from before to gain access to the Admin 
GUI. You should be able to access all resources.

> Note: Once Kong starts, you will notice that your 
[Admin API configuration](https://127.0.0.1:8001/) now shows `cors` and `key-auth`
plugins are enabled. This is because Kong sets up an internal proxy to the Admin
API (i.e., `:8001` -> `:8000/_kong/admin`) and configures the Key Authentication
plugin applied only to all routes. These routes &amp; services will not be
tracked by Kong Vitals, they will not appear in your proxy traffic, and the
internal plugins will not be applied to any other routes or services or be
configurable in your Kong instance.

The Admin GUI supports other Authentication plugins which are explained in more detail 
under [Example configurations](#example-configs):

* [LDAP Authentication Advanced](/enterprise/{{page.kong_version}}/plugins/ldap-authentication-advanced)
* [Basic Authentication](https://getkong.org/plugins/basic-authentication)

## Add a Credential

If you are using Basic Authentication or Key Authentication, then you will need
to add a credential.

## Example configurations

Set `enforce_rbac = on` in your Kong configuration.

⚠️ **IMPORTANT**: When RBAC is `off`, any consumer with a valid credential can
log in to the Admin GUI, so you must enable RBAC if you want to restrict access
only to admins.

### Key Authentication

Check out the section [Enabling Authentication](#enable-authentication) for a 
step by step guide on setting up 
[Key Authentication](https://getkong.org/plugins/key-authentication).

### LDAP Authentication

The [LDAP Authentication Advanced plugin](/enterprise/{{page.kong_version}}/plugins/ldap-authentication-advanced)
allows Admins to use their own LDAP server 
to bind authentication to the Admin API with username and password protection. 
Note: You must use `Basic` as your `header_type` in the `admin_gui_auth_config` 
Kong configuration. Here is an example configuration (update the following in your 
Kong Configuration, then restart Kong):

```
admin_gui_auth = ldap-auth-advanced
enforce_rbac = on
```

```
admin_gui_auth_conf={                                     \
"anonymous":"",                                           \
"attribute":"uid",                                        \ 
"base_dn":"<ENTER_YOUR_BASE_DN_HERE>",                    \
"cache_ttl": 2,                                           \
"header_type":"Basic",                                    \
"keepalive":60000,                                        \
"ldap_host":"<ENTER_YOUR_LDAP_HOST_HERE>",                \
"ldap_port":389,                                          \
"start_tls":false,                                        \
"timeout":10000,                                          \
"verify_ldap_host":true                                   \
}
```

The values above can be replaced with their corresponding values for your custom 
LDAP configuration:

  - `<ENTER_YOUR_BASE_DN_HERE>` - Your LDAP Base DN (Distinguished Name)
        * For Example, `ou=scientists,dc=ldap,dc=kong,dc=com`
  - `<ENTER_YOUR_LDAP_HOST_HERE>` - LDAP Host domain
        * For Example, `ec2"-XX-XXX-XX-XXX.compute-1.amazonaws.com`

After you have updated your configuration and restarted Kong, you will now be 
able to login to the Admin GUI with a username and password validated against 
your remote LDAP server.

### Basic Authentication

The [Basic Authentication Plugin](https://getkong.org/plugins/basic-authentication) 
allows Admins to use username and password to authenticate requests, and can be 
used to authenticate the Admin GUI.

Create an Admin and Basic Auth Credential:

```bash
curl -X POST http://kong:8001/admins/    \
    --data "username=<USERNAME>"         \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created

{
  "rbac_user": {
    "comment": "User generated on creation of Admin.",
    "user_token": "a3cebf9e-820d-4543-b760-2b6986e3bb9d",
    "id": "1e24c54d-e575-4910-8a58-4d5f7203be08",
    "name": "user-<USERNAME>-<CUSTOM_ID>",
    "created_at": 1530577554000,
    "enabled": true
  },
  "consumer": {
    "custom_id": "<CUSTOM_ID>",
    "created_at": 1530577554000,
    "id": "1f8c8ce4-7625-4fa4-8904-6a2a507ffa93",
    "status": 0,
    "username": "<USERNAME>",
    "type": 2
  }
}
```

Create the credential:

```bash
curl -X POST http://kong:8001/consumers/{consumer}/basic-auth \
    --data "username=Aladdin" \
    --data "password=OpenSesame"
HTTP/1.1 201 Created

{
  "created_at": 1530652974000,
  "id": "ee05f09f-53aa-4e8c-908a-6538a1bda42f",
  "username": "Aladdin",
  "password": "80b9fa1953449090eeaa7842283f18115195af41",
  "consumer_id": "01a8d15a-4117-437b-be8b-debf52380bc4"
}
```

Update the following in your Kong Configuration, then restart Kong:

```
admin_gui_auth = basic-auth
enforce_rbac = on
```

Browse to the Admin GUI and you should now see [Login](#logging-in). The form 
will reflect that admins now need a username and password to login and administer 
Kong. Login with the username password created `Aladdin:OpenSesame`.


## Logging In

Ensure you are logged out (see section [Logging Out](#logging-out)). Visit the 
Admin GUI, where you will be prompted with a login form.

When you submit the login form, the Admin GUI will make a request against the Admin 
API using the specified `admin_gui_auth` with the data in the form. For instance, 
if you have `basic-auth` enabled, then the form will submit with the Authorization 
header e.g. `Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=`. If successful, 
credentials will be [stored in the browser](#how-authentication-is-stored-in-local-storage) 
and used for subsequent browser requests.

## Logging Out 👋🏻

Click the "Logout" button in the top right. This will clear the Local Storage 
authentication data (if exists) and redirect to the login page.

## How Authentication is Stored in Local Storage

The Admin GUI uses the [Local Storage API](https://developer.mozilla.org/en-US/Web/API/Window/localStorage) 
to store and retrieve Authentication credentials, parameters, and headers. Local 
Storage is saved on every successful login, and it is retrieved on every Admin 
GUI API XHR request based on the `auth-store-types` value, until you 
[logout](#logging-out).

⚠️ **IMPORTANT**: Local Storage Authentication credentials are stored in the 
browser via base64-encoding, but are not encrypted. Therefore, it advised that 
you always used SSL/TLS to encrypt your Admin GUI traffic.

Next: [Managing Admins &rsaquo;]({{page.book.next}})
