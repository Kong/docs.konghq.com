---
title: Enable OIDC for Kong Manager
badge: enterprise
---

{{site.base_gateway}} offers the ability to bind authentication for Kong
Manager **Admins** to an organization's OpenID Connect Identity
Provider using the
**[OpenID Connect Plugin](/hub/kong-inc/openid-connect/)**.

**Note**: by using the configuration below, it is unnecessary to
manually enable the **Plugin**; the configuration alone will enable
**OIDC** for Kong Manager.

## Set up RBAC with OIDC

The following is an example using Google as the IdP and serving Kong Manager
from its default URL, `http://127.0.0.1:8002`.

(The `admin_gui_auth_conf` value must be valid JSON.)

```
enforce_rbac = on
admin_gui_auth=openid-connect
admin_gui_session_conf = { "secret":"set-your-string-here" }
admin_gui_auth_conf={                                      \
  "issuer": "https://accounts.google.com/",                \
  "admin_claim": "email",                  \ 
  "client_id": ["<ENTER_YOUR_CLIENT_ID>"],                 \
  "client_secret": ["<ENTER_YOUR_CLIENT_SECRET_HERE>"],    \  
  "admin_by": "username",                                \ 
  "authenticated_groups_claim": ["<workspace_name>:role_name>", \
  "ssl_verify": false,                                     \
  "leeway": 60,                                            \
  "redirect_uri": ["http://localhost:8002"],               \
  "login_redirect_uri": ["http://localhost:8002"],         \
  "logout_methods": ["GET", "DELETE"],                     \
  "logout_query_arg": "logout",                            \
  "logout_redirect_uri": ["http://localhost:8002"],        \
  "scopes": ["openid","profile","email","offline_access"], \
  "auth_methods": ["authorization_code"]                   \
}
```

The **Sessions Plugin** requries a secret and is configured securely by default.
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`.
Learn more about these properties in [Session Security in Kong Manager](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/#session-security), and see [example configurations](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/#example-configurations).

Replace the entries surrounded by `<>` with values that are valid for your IdP.
For example, Google credentials can be found here:
https://console.cloud.google.com/projectselector/apis/credentials

