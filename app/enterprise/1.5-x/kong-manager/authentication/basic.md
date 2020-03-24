---
title: Enable Basic Auth for Kong Manager
book: admin_gui
toc: false
---

#### Table of Contents:
- [Prerequisites](#prerequisites)
- [Step 1](#step-1)
- [Step 2](#step-2)

### Prerequisites

To enable Basic Authentication, configure Kong with the following properties:

```
enforce_rbac = on
admin_gui_auth = basic-auth
admin_gui_session_conf = { "secret":"set-your-string-here" }
```

⚠️**Important:** the **Sessions Plugin** requries a secret and is configured securely by default. 
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`. 
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`. 
Learn more about these properties in [Session Security in Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security), and see [example configurations](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#example-configurations).

## Step 1

Start Kong:

```
$ kong start [-c /path/to/kong/conf]
```

## Step 2

If you created a **Super Admin** via database migration, log in to Kong 
Manager with the username `kong_admin` and the password 
set in the environment variable.

If you created a Super Admin via the Kong Manager "Organization" tab 
as described in 
[How to Create a Super Admin](/enterprise/{{page.kong_version}}/kong-manager/authentication/super-admin), 
log in with the credentials you created after accepting the email 
invitation.
