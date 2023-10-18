---
title: Enable OIDC for Kong Manager
badge: enterprise
---

{{site.base_gateway}} offers the ability to bind authentication for Kong
Manager admins  to an organization's OpenID Connect Identity
Provider using the
[OpenID Connect Plugin](/hub/kong-inc/openid-connect/).

{:.note}
> **Note**: By using the configuration below, it is unnecessary to
manually enable the plugin. The configuration alone will enable
OIDC for Kong Manager.

## Set up RBAC with OIDC

The following is an example using Google as the IdP and serving Kong Manager
from its default URL, `http://127.0.0.1:8002`.

The `admin_gui_auth_config` value must be valid JSON. Here is an example setting template.

```
enforce_rbac = on
admin_gui_auth=openid-connect
admin_gui_session_conf = { "secret":"set-your-string-here" }
admin_gui_auth_conf={                                      \
  "issuer": "https://accounts.google.com/",                \
  "client_id": ["<ENTER_YOUR_CLIENT_ID>"],                 \
  "client_secret": ["<ENTER_YOUR_CLIENT_SECRET_HERE>"],    \
  "authenticated_groups_claim": ["groups"],                \
  "admin_claim": ["email"],                                \
  "redirect_uri": ["http://localhost:8002/default"],       \
}
```
Required for `admin_gui_auth_conf` of `openid-connect`
| item                       | required | data type | default value                      | remark                                                                                                |
|----------------------------|----------|-----------|------------------------------------|-------------------------------------------------------------------------------------------------------|
| issuer                     | true     | String    | "input idp issuer"                 | A string representing a URL                                                                           |
| client_id                  | true     | Array     | ["input idp client_id"]            | The client id(s) that the plugin uses when it calls authenticated endpoints on the identity provider. |
| client_secret              | true     | Array     | ["input client secret"]            | The client secret.                                                                                    |
| redirect_uri               | true     | Array     | _["input http://ip:8002/default"]_ | The redirect URI passed to the authorization and token endpoints.                                     |
| authenticated_groups_claim | true     | Array     | ["groups"]                         | The claim that contains authenticated groups.                                                         |
| admin_claim                | true     | Array     | ["email"]                          | Retrieve the field as a username.                                                                     |
| admin_auto_create          | false    | Boolean   | true                               | This parameter is used to enable the automatic creation of administrators.                            |
| ssl_verify                 | false    | Boolean   | false                              | Verify identity provider server certificate.                                                          |

The **Sessions plugin** (configured with `admin_gui_session_conf`) requires a secret and is configured securely by default.
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
{% if_version lte:3.1.x %}
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`.
{% endif_version %}
{% if_version gte:3.2.x %}
* If using different domains for the Admin API and Kong Manager, `cookie_same_site` must be set to `Lax`.
{% endif_version %}

Learn more about these properties in [Session Security in Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth//sessions/#session-security), and see [example configurations](/gateway/{{page.kong_version}}/kong-manager/auth/sessions/#example-configurations).

Replace the entries surrounded by `<>` with values that are valid for your IdP.
For example, Google credentials can be found here:
[https://console.cloud.google.com/projectselector/apis/credentials](https://console.cloud.google.com/projectselector/apis/credentials)

## Create an admin

Create an admin that has a username matching the email returned from
the identity provider upon successful login:

```bash
curl -i -X POST http://localhost:8001/admins \
  --data username="<admin_email>" \
  --data email="<admin_email>" \
  --header Kong-Admin-Token:<RBAC_TOKEN>
```

For example, if a user has the email address `example_user@example.com`:

```bash
curl -i -X POST http://localhost:8001/admins \
  --data username="example_user@example_com" \
  --data email="example_user@example.com" \
  --header Kong-Admin-Token:<RBAC_TOKEN>
```

{:.note}
> **Note:** The email entered for the admin in the request is used to
ensure the admin receives an email invitation, whereas username is the
attribute that the plugin uses with the IdP.

## Assign a role to the admin

Assign the new admin at least one role so they can log in and access
Kong entities:

```bash
curl -i -X POST http://localhost:8001/admins/<admin_email>/roles \
  --data roles="<role-name>" \
  --header Kong-Admin-Token:<RBAC_TOKEN>
```

For example, to grant `example_user@example.com` the role of super admin:

```bash
curl -i -X POST http://localhost:8001/admins/example_user@example.com/roles \
  --data roles="super-admin" \
  --header Kong-Admin-Token:<RBAC_TOKEN>
```
