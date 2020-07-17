---
title: Enable Key Auth in the Dev Portal
---

### Introduction

The Kong Developer Portal can be fully or partially authenticated using API keys or **Key
Authentication**. Users provide a unique key upon registering and use this key
to log into the Dev Portal.

Key Authentication for the Dev Portal can be enabled in three ways:

- via the [Kong Manager](#enable-key-auth-via-kong-manager)
- via the [the command line](#enable-key-auth-via-the-command-line)
- via the [the Kong configuration file](#enable-key-auth-via-the-kongconf)

>**Warning** Enabling authentication in the Dev Portal requires use of the
> Sessions plugin. Developers will not be able to login if this is not set
> properly. More information about [Sessions in the Dev Portal](/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication/sessions)

### Enable Portal Session Config

```
portal_session_conf={ "cookie_name": "portal_session", "secret": "CHANGE_THIS", "storage": "kong" }
```

If using HTTP while testing, include `"cookie_secure": false` in the config:

```
portal_session_conf={ "cookie_name": "portal_session", "secret": "CHANGE_THIS", "storage": "kong", "cookie_secure": false }
```

### Enable Key Auth via Kong Manager

1. Navigate to the Dev Portal's **Settings** page.
2. Find **Authentication plugin** under the **Authentication** tab.
3. Select **Key Authentication** from the drop down.
4. Click **Save Changes**.

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable Key Auth via the Command Line

To patch a Dev Portal's authentication property directly, run:

```
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE NAME> \
  --data "config.portal_auth=key-auth"
```

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable Key Auth via the Kong.conf

Kong allows for a `default authentication plugin` to be set in the Kong
configuration file with the `portal_auth` property.

In your `kong.conf` file, set the property as follows:

```
portal_auth="key-auth"
```

This will set every Dev Portal to use Key Authentication by default when
initialized, regardless of Workspace.
