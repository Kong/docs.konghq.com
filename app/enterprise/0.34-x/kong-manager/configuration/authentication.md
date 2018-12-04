---
title: Authenticating Kong Manager
book: admin_gui
chapter: 3
---

> Before beginning, ensure completion of the steps in 
[Getting Started with Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/configuration/getting-started)

Kong has the ability to verify the identity of all users with Basic 
Authentication or LDAP Authentication. 

## How to Enable Basic Authentication

To enable Basic Authentication, ensure that in `kong.conf.default`:

```
enforce_rbac = on
admin_gui_auth = basic-auth
```

## How to Log In as the First Super Admin

To create the first Super Admin account:

1. Set the Super Admin's password. 

      ```
      $ export KONG_ADMIN_PASSWORD=<password-only-you-know>
      ```

2. Run migrations. 

      ```
      $ kong migrations up [-c /path/to/kong/conf]
      ```

3. Start Kong.

      ```
      $ kong start [-c /path/to/kong/conf]
      ```

4. Log in to Kong Manager with the username `kong_admin` and the password set 
in step 1.

![Log in to Kong Manager](https://konghq.com/wp-content/uploads/2018/11/km-rename.png)

## Authentication Stored in Local Storage

Kong Manager uses the 
[Local Storage API](https://developer.mozilla.org/en-US/Web/API/Window/localStorage) 
to store and retrieve the RBAC token, parameters, and headers. Local Storage is 
saved on every successful login, and it is retrieved on every Kong Manager API 
XHR request based on the `auth-store-types` value until you log out.

⚠️ **IMPORTANT**: Information in Local Storage, including the current 
user's RBAC token, is stored in the browser via `base64-encoding`, but 
is not encrypted. Therefore, it advised that you always use SSL/TLS to 
encrypt your Kong Manager traffic.

## How to Log Out and Log In

1. Hover over the account name at the top right, and click the "Logout" button. 
This will clear the Local Storage authentication data (if exists) and redirect 
to the login page.

2. *Ensure you are logged out* before attempting to log in with a different 
account. Visit Kong Manager, where you will be prompted with a login form.

3. When you submit the login form, Kong Manager will make a request against the 
Admin API using the specified `admin_gui_auth` with the data in the form. For 
instance, if you have `basic-auth` enabled, then the form will submit with the 
Authorization header; e.g., `Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=`. 

4. If successful, the RBAC token associated with this Admin will be stored 
locally and used for subsequent browser requests.

## LDAP Authentication

The [LDAP Authentication Advanced plugin](/enterprise/{{page.kong_version}}/plugins/ldap-authentication-advanced) 
allows Admins to use their own LDAP server to bind authentication to the Admin 
API with username and password protection. Note: You must use `Basic` as your 
`header_type` in the `admin_gui_auth_config` Kong configuration. To implement 
this (and any other) configuration, restart Kong after saving changes to 
`kong.conf`:

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

The values above can be replaced with their corresponding values for your 
custom LDAP configuration:

  - `<ENTER_YOUR_BASE_DN_HERE>` - Your LDAP Base DN (Distinguished Name)
        * For Example, `ou=scientists,dc=ldap,dc=kong,dc=com`
  - `<ENTER_YOUR_LDAP_HOST_HERE>` - LDAP Host domain
        * For Example, `ec2"-XX-XXX-XX-XXX.compute-1.amazonaws.com`

After you have updated your configuration and restarted Kong, you will now be 
able to login to Kong Manager with a username and password validated against 
your remote LDAP server.

Next: [Networking &rsaquo;]({{page.book.next}})
