---
title: Authenticating the Admin GUI
book: admin_gui
chapter: 3
---

> Before you begin, make sure you have gone through the
[Getting Started with the Admin GUI](https://getkong.org/enterprise/{{page.kong_version}}/admin-gui/configuration/getting-started)

## Enable Authentication

There are a couple of pieces of information that are important to understand when using authentication for the Admin GUI:

- The Admin GUI is a JavaScript application that runs in the browser, and makes calls to the Admin API
- For locking down the GUI, a private endpoint is configured on the proxy side, and an auth plugin is enabled
- The Admin GUI JavaScript application uses this proxy side endpoint to talk to the Admin API
- Two pieces of authentication need to be enabled in order for the Admin GUI to talk to the Admin API in this setup
- The "Admin user" is a combination of a rbac user and a consumer of type 'admin' that only appears on the `/admins` endpoint and is filtered out from `/consumers` endpoints. Admins as consumers allows Kong to use plugins on an admin to authenticate
- This Admin needs to be in an RBAC group with access to the Admin API
- This Admin needs to have access to the `admin_gui_auth` specified plugin

Knowing that we will follow these steps:

1. [Create a new Admin user](#first)
2. [Add the Admin user's "rbac user" to the rbac `super-user` group](#second)
3. [Add a key-auth key to the Admin user's "hidden consumer"](#third)
4. [Enable RBAC and the Admin GUI Auth method in the config](#fourth)
5. [Restart Kong](#fifth)


In this example we will configure authentication on the Admin GUI using [Key Authentication](https://getkong.org/plugins/key-authentication).

<a name="first"></a>
**First, we will add an Admin entity using the Admin API:**

```bash
curl -X POST http://localhost:8001/admins -d 'username=myadmin'

{
  "rbac_user": {
    "comment": "User generated on creation of Admin.",
    "user_token": "406ee936-4a10-41c0-a9e5-7b9f7b6fc106",
    "id": "98af4bda-8525-44a6-a745-0c503b146639",
    "name": "user-myadmin",
    "created_at": 1537966410000,
    "enabled": true
  },
  "consumer": {
    "created_at": 1537966410000,
    "id": "94110df6-211a-4f89-b4f3-0a994753ddf9",
    "status": 0,
    "username": "myadmin",
    "type": 2
  }
}
```

Save the generated rbac user's `user_token` (`406ee936-4a10-41c0-a9e5-7b9f7b6fc106` in the
example above) for use later. It must be sent in the `Kong-Admin-Token` header
when RBAC is enabled if using a client (e.g. cURL or HTTPie) other than the
Admin GUI.

We can test that the consumer that was created (id `94110df6-211a-4f89-b4f3-0a994753ddf9`) is in fact filtered from the `/consumers` endpoint.

```bash
curl -X GET http://localhost:8001/consumers/

{
  "total": 0,
  "data": []
}
```

<a name="second"></a>
**Second, we will add the Admin user's "rbac user" to the super-admin group:**

In this example we are using the `super-admin` group for simplicity, however
you may want to use a different group that you have configured with limited
RBAC permissions. Read [Bootstrapping the first RBAC user - the Super Admin](/enterprise/{{page.kong_version}}/rbac/examples/#bootstrapping-the-first-rbac-user-the-super-admin) for more information.

```bash
curl -X POST http://localhost:8001/rbac/users/98af4bda-8525-44a6-a745-0c503b146639/roles -d 'roles=super-admin'

{
  "roles": [
    {
      "comment": "Default user role generated for user-myadmin",
      "created_at": 1537966410000,
      "id": "63be0c50-1a12-4483-986a-92bc5d3302b3",
      "name": "user-myadmin"
    },
    {
      "comment": "Full access to all endpoints, across all workspaces",
      "created_at": 1537965959000,
      "id": "5be18384-ff74-4242-96a6-36d5fa85af55",
      "name": "super-admin"
    }
  ],
  "user": {
    "comment": "User generated on creation of Admin.",
    "user_token": "406ee936-4a10-41c0-a9e5-7b9f7b6fc106",
    "id": "98af4bda-8525-44a6-a745-0c503b146639",
    "name": "user-myadmin",
    "enabled": true,
    "created_at": 1537966410000
  }
}
```

<a name="third"></a>
**Third, you must provision a Key-Auth api key for the Admin user's "hidden consumer":**

Note, in this example we are using key-auth; for other auth methods you will
need to provisions the approprate key/password needed for that method.

```bash
curl -X POST http://localhost:8001/consumers/94110df6-211a-4f89-b4f3-0a994753ddf9/key-auth -d ''

{
  "created_at": 1537966734000,
  "id": "ea20b2c6-a1c8-4f2e-8cbe-97f802506b6e",
  "key": "Au5sciJOadbGyDAk6ZqndKH8IQFzKZ5x",
  "consumer_id": "94110df6-211a-4f89-b4f3-0a994753ddf9"
}
```

Save this key `Au5sciJOadbGyDAk6ZqndKH8IQFzKZ5x` for later, it is used at the
Admin GUI login prompt. Note that this key is separate and distinct from the
admin's RBAC token.


<a name="fourth"></a>
**Fourth, update the config to enable RBAC and the Admin GUI auth method:**

Using the kong.conf file:

```bash
enforce_rbac = on
admin_gui_auth = key-auth
```

Using environmental variables:

```bash
KONG_ENFORCE_RBAC = on
KONG_ADMIN_GUI_AUTH = key-auth
```

<a name="fifth"></a>
**Fifth, restart Kong.**

The Admin GUI is now aware that authentication is enabled and will restrict
access so that only the Admin users with an api key and in the RBAC
`super-admin` group can log in. Browse to the Admin GUI and you will be
prompted with a [Login](#logging-in) form. Enter in the api key saved from
before to gain access to the Admin GUI. You should be able to access all
resources.

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
allows Admins to use their own LDAP server to bind authentication to the Admin 
API with username and password protection. Note: You must use `Basic` as your 
`header_type` in the `admin_gui_auth_config` Kong configuration. Here is an 
example configuration (update the following in your Kong Configuration, then 
restart Kong):

```
admin_gui_auth = ldap-auth-advanced
enforce_rbac = on
```

```
admin_gui_auth_conf={                                     \
"anonymous":"",                                           \
"attribute":"uid",                                        \
"bind_dn":"<ENTER_YOUR_BIND_DN_HERE>",                    \
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

  - `<ENTER_YOUR_BIND_DN_HERE>` - Your LDAP Bind DN (Distinguished Name)
        * Used to perform LDAP search of user. This bind_dn should have 
          permissions to search for the user being authenticated.
        * For Example, `uid=einstein,ou=scientists,dc=ldap,dc=com`
  - `<ENTER_YOUR_BASE_DN_HERE>` - Your LDAP Base DN (Distinguished Name)
        * For Example, `ou=scientists,dc=ldap,dc=com`
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
