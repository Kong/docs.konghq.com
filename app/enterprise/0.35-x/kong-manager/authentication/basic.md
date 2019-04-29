---
title: How to Enable Basic Auth for Kong Manager
book: admin_gui
---

1. To enable Basic Authentication, configure Kong with the following properties:

```
enforce_rbac = on
admin_gui_auth = basic-auth
```

2. Start Kong:

```
$ kong start [-c /path/to/kong/conf]
```

3. If you created a **Super Admin** via database migration, log in to Kong 
Manager with the username `kong_admin` and the password 
set in the environment variable.

If you created a Super Admin via the Kong Manager "Organization" tab 
as described in 
[How to Create a Super Admin](/enterprise/{{page.kong_version}}/kong-manager/authentication/super-admin), 
log in with the credentials you created after accepting the email 
invitation.