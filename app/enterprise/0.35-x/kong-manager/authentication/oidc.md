---
title: How to Enable OIDC for Kong Manager
book: admin_gui
---

Here is an example using Google as the IdP and serving Kong Manager from its default URL, http://127.0.0.1:8002:

```
enforce_rbac = on
admin_gui_auth=openid-connect
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

The admin_gui_auth_config value must be valid JSON.

Replace the entries surrounded by <> with values that are valid for your IdP. For example, Google credentials can be found here: https://console.cloud.google.com/projectselector/apis/credentials

1. Create an admin that has a username of the email returned from the Identity Provider upon successful login.
$ http POST :8001/admins username="<your_email>" email="<your_email>" Kong-Admin-Token:<RBAC_TOKEN>

2. The email entered for the Admin is not used by the OIDC Plugin, it is just there to ensure the Admin gets an email saying they have been invited if smtp is enabled.

3. Assign them at least one role so they can login and do something
$ http POST :8001/admins/<your_email>/roles roles="admin"

Login to the manager with the email address you provided.
