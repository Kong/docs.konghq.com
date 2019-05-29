---
title: How to Enable OIDC for Kong Manager
book: admin_gui
toc: false
---
#### Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step 1](#step-1)
- [Step 2](#step-2)

### Introduction

Kong Enterprise offers the ability to bind authentication for Kong 
Manager **Admins** to an organization's OpenID Connect Identity 
Provider using the 
**[OpenID Connect Plugin](/hub/kong-inc/openid-connect/)**.

**Note**: by using the configuration below, it is unnecessary to 
manually enable the **Plugin**; the configuration alone will enable 
**OIDC** for Kong Manager.

### Prerequisites

The following is an example using Google as the IdP and serving Kong Manager from its default URL, `http://127.0.0.1:8002`.

(The `admin_gui_auth_config` value must be valid JSON.)

```
enforce_rbac = on
admin_gui_auth=openid-connect
admin_gui_session_conf = { "secret":"set-your-string-here" }
admin_gui_auth_conf={                                      \
  "issuer": "https://accounts.google.com/",                \
  "client_id": ["<ENTER_YOUR_CLIENT_ID>"],                 \
  "client_secret": ["<ENTER_YOUR_CLIENT_SECRET_HERE>"],    \
  "consumer_by": ["username","custom_id"],                 \
  "ssl_verify": false,                                     \
  "consumer_claim": ["email"],                             \
  "leeway": 60,                                            \
  "redirect_uri": ["localhost:8002"],                      \
  "login_redirect_uri": ["localhost:8002"],                \
  "logout_methods": ["GET", "DELETE"],                     \
  "logout_query_arg": "logout",                            \
  "logout_redirect_uri": ["localhost:8002"],               \
  "scopes": ["openid","profile","email","offline_access"], \
  "auth_methods": ["authorization_code"]                   \
}
```

⚠️**Important:** the **Sessions Plugin** requries a secret and is configured securely by default. 
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`. 
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`. 
Learn more about these properties in [Session Security in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security), and see [example configurations](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#example-configurations).

Replace the entries surrounded by `<>` with values that are valid for your IdP. For example, Google credentials can be found here: https://console.cloud.google.com/projectselector/apis/credentials

## Step 1

Create an **Admin** that has a **username** matching the **email** returned from the Identity Provider upon successful login.

```bash
$ http POST :8001/admins username="<admin_email>" email="<admin_email>" Kong-Admin-Token:<RBAC_TOKEN>
```

For example, if a user has a Google email address, **hal9000@sky.net**: 

```bash
$ http POST :8001/admins username="hal9000@sky.net" email="hal9000@sky.net" Kong-Admin-Token:<RBAC_TOKEN>
```

**Note:** The **email** entered for the **Admin** in the request is used to ensure the **Admin** receives an email invitation, whereas **username** is the attribute that the **Plugin** uses with the IdP. 

## Step 2

Assign the new **Admin** at least one **Role** so they can log in and access Kong entities. 

```bash
$ http POST :8001/admins/<admin_email>/roles roles="<role-name>"
```

For example, if we wanted to grant **hal9000@sky.net** the **Role** of **Super Admin**:

```bash
$ http POST :8001/admins/hal9000@sky.net/roles roles="super-admin"
```