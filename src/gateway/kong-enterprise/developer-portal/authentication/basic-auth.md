---
title: Enable Basic Auth in the Dev Portal
badge: enterprise
---

The Kong Dev Portal can be fully or partially authenticated using HTTP protocol's Basic Authentication scheme. Requests are sent with an Authorization header that
contains the word `Basic` followed by the base64-encoded `username:password` string.

Basic Authentication for the Dev Portal can be enabled using any of the following ways:

- [Kong Manager](#enable-basic-auth-using-kong-manager)
- [Command line](#enable-basic-auth-using-the-command-line)
- [Kong configuration file](#enable-basic-auth-using-kongconf)

**Warnings:**

- Enabling authentication in the Dev Portal requires use of the
Sessions plugin. Developers will not be able to log in if this is not properly set.
For more information, see
[Sessions in the Dev Portal](/gateway/{{page.kong_version}}/developer-portal/configuration/authentication/sessions).

- When Dev Portal Authentication is enabled, content files remain unauthenticated until a role is applied to them. The exceptions are `settings.txt` and `dashboard.txt`, which begin with the `*` role. For more information, see
[Developer Roles and Content Permissions](/gateway/{{page.kong_version}}/developer-portal/administration/developer-permissions).


## Enable Portal Session Config

In the Kong configuration file, set the `portal_session_conf` property:

```
portal_session_conf={ "cookie_name":"portal_session","secret":"<CHANGE_THIS>","storage":"kong"}
```

If using HTTP while testing, include `"cookie_secure": false` in the config:

```
portal_session_conf={ "cookie_name":"portal_session","secret":"<CHANGE_THIS>","storage":"kong","cookie_secure":false}
```

Or, if you have different subdomains for the `portal_api_url` and `portal_gui_host`, set the `cookie_domain`
and `cookie_samesite` properties as follows:

```
portal_session_conf={ "cookie_name":"portal_session","secret":"<CHANGE_THIS>","storage":"kong","cookie_secure":false,"cookie_domain":"<.your_subdomain.com>","cookie_samesite":"off"  }
```

### See Also

- For more information about portal session configuration, see
[Sessions](/gateway/{{page.kong_version}}/developer-portal/configuration/authentication/sessions#portal-session-conf).

- For more information about domains and cookies in Dev Portal sessions, see
[Domains](/gateway/{{page.kong_version}}/developer-portal/configuration/authentication/sessions#domains).

## Enable Basic Auth Using Kong Manager

1. Navigate to the Dev Portal's **Settings** page.
2. Find **Authentication plugin** under the **Authentication** tab.
3. Select **Basic Authentication**.
4. Click **Save Changes**.

![Authentication plugin](/assets/images/docs/dev-portal/portal-settings-auth-plugin.png)

## Enable Basic Auth Using the Command Line

To patch a Dev Portal's authentication property directly, run:

```bash
$ curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE_NAME> \
  --data "config.portal_auth=basic-auth"
```

## Enable Basic Auth Using `kong.conf`

Kong allows for a default authentication plugin to be set in the Kong
configuration file with the `portal_auth` property.

In your `kong.conf` file, set the property as follows:

```
portal_auth="basic-auth"
```

This sets all Dev Portals to use Basic Authentication by default when initialized.
