---
title: Authenticating Kong Manager
book: admin_gui
chapter: 3
---

> Before beginning, ensure completion of the steps in 
[Getting Started with Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/configuration/getting-started)

Kong can verify the identity of all users with Basic 
Authentication or LDAP Authentication Advanced. 

⚠️ **IMPORTANT**: Before enabling authentication, ensure that you
have at least one Super Admin account. You may have set one up during
the [Quick Start](/enterprise/{{page.kong_version}}/getting-started/quickstart),
or you can set one up on the Organization page of Kong Manager.

## How to Set Up a Super Admin

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2019/02/org-super-admin-ent-34.mov" type="video/mp4">
  Your browser does not support the video tag.
</video>

1. Go to the "Organization" tab in Kong Manager.

2. Click "+Invite User" and fill out the form. 

3. Give the user the `super-admin` role in the `default` workspace.

4. Return to the "Organization" page, and in the "Invited" section, click
the email address of the user in order to view them.

5. Click "Generate Registration Link". 

6. Copy the link for later use after completing the account setup.

## How to Enable Basic Authentication

To enable Basic Authentication, configure Kong with the following properties:

```
enforce_rbac = on
admin_gui_auth = basic-auth
```

Start Kong:

```
$ kong start [-c /path/to/kong/conf]
```

## How to Log In

If you created a Super Admin via database migration as per the 
[Quick Start](/enterprise/{{page.kong_version}}/getting-started/quickstart) 
guide, log in to Kong Manager with the username `kong_admin` and the password 
set in the environment variable.

If you created a Super Admin via the Kong Manager "Organization" tab, browse
to the registration link you copied in 
["How to Set Up a Super Admin"](/enterprise/{{page.kong_version}}/kong-manager/configuration/authentication#how-to-set-up-a-super-admin)
, Step 4.

Fill out the form to create your basic auth credentials. Now you can log in.

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

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2019/02/logout-login-enterprise-34.mov" type="video/mp4">
  Your browser does not support the video tag.
</video>

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

Kong Enterprise offers the ability to bind authentication for Kong Manager 
*Admins* to a company's Active Directory using the 
[LDAP Authentication Advanced plugin](/enterprise/{{page.kong_version}}/plugins/ldap-authentication-advanced).

⚠️ **IMPORTANT**: by using the configuration below, it is unnecessary to manually apply
the plugin; the configuration alone will enable LDAP Authentication for Kong Manager.

Ensure Kong is configured with the following properties either in the configuration 
file or using environment variables:

```
admin_gui_auth = ldap-auth-advanced
enforce_rbac = on
admin_gui_auth_conf = {                                   
    "anonymous":"",                                           \
    "attribute":"<ENTER_YOUR_ATTRIBUTE_HERE>",                \ 
    "bind_dn":"<ENTER_YOUR_BIND_DN_HERE>",                    \
    "base_dn":"<ENTER_YOUR_BASE_DN_HERE>",                    \
    "cache_ttl": 2,                                           \
    "header_type":"Basic",                                    \
    "keepalive":60000,                                        \
    "ldap_host":"<ENTER_YOUR_LDAP_HOST_HERE>",                \
    "ldap_password":"<ENTER_YOUR_LDAP_PASSWORD_HERE>",        \
    "ldap_port":389,                                          \
    "start_tls":false,                                        \
    "timeout":10000,                                          \
    "verify_ldap_host":true                                   \
    "consumer_by":"username",                                 \
}
```

* `"attribute":"<ENTER_YOUR_ATTRIBUTE_HERE>"`: The attribute used to identify LDAP users
    * For example, to map LDAP users to admins by their username, `"attribute":"uid"`
* `"bind_dn":"<ENTER_YOUR_BIND_DN_HERE>"`: LDAP Bind DN (Distinguished Name) 
    * Used to perform LDAP search of user. This bind_dn should have permissions to search 
      for the user being authenticated. 
    * For example, `uid=einstein,ou=scientists,dc=ldap,dc=com`
* `"base_dn":"<ENTER_YOUR_BASE_DN_HERE>"`: LDAP Base DN (Distinguished Name) 
    * For example, `ou=scientists,dc=ldap,dc=com`
* `"ldap_host":"<ENTER_YOUR_LDAP_HOST_HERE>"`: LDAP host domain 
    * For example, `"ec2-XX-XXX-XX-XXX.compute-1.amazonaws.com"`
* `"ldap_password":"<ENTER_YOUR_LDAP_PASSWORD_HERE>"`: LDAP password
    * *Note*: As with any configuration property, sensitive information may be set as an 
      environment variable instead of being written directly in the configuration file.

After starting Kong with the desired configuration, you may create new *Admins* whose
usernames match those in the AD. Those users will then be able to accept invitations
to join Kong Manager and log in with their LDAP credentials.

Next: [Networking &rsaquo;]({{page.book.next}})
