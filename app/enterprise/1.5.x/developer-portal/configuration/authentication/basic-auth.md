---
title: Enable Basic Auth in the Dev Portal
---

### Introduction

The Kong Developer Portal can be fully or partially authenticated using HTTP protocol's Basic Authentication scheme. Requests will be sent with the Authorization header that
contains the word `Basic` followed by the base64-encoded `username:password` string.

Basic Authentication for the Dev Portal can be enabled in three ways:

- via the [Kong Manager](#enable-basic-auth-via-kong-manager)
- via the [the command line](#enable-basic-auth-via-the-command-line)
- via the [the Kong configuration file](#enable-basic-auth-via-the-kong-conf)

>**Warning** Enabling authentication in the Dev Portal requires use of the
> Sessions plugin. Developers will not be able to login if this is not set
> properly. More information about [Sessions in the Dev Portal](/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication/sessions)

### Enable Portal Session Config

In the the Kong configuration file set the `portal_session_conf` property:

```
portal_session_conf={ "cookie_name": "portal_session", "secret": "CHANGE_THIS", "storage": "kong" }
```

If using HTTP while testing, include `"cookie_secure": false` in the config:

```
portal_session_conf={ "cookie_name": "portal_session", "secret": "CHANGE_THIS", "storage": "kong", "cookie_secure": false }
```

### Enable Basic Auth via Kong Manager

1. Navigate to the Dev Portal's **Settings** page
2. Find **Authentication plugin** under the **Authentication** tab
3. Select **Basic Authentication** from the drop down
4. Click the **Save Changes** button at the bottom of the form

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable Basic Auth via the Command Line

To patch a Dev Portal's authentication property directly run:

```
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE NAME> \
  --data "config.portal_auth=basic-auth"
```

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable Basic Auth via the Kong.conf

Kong allows for a `default authentication plugin` to be set in the Kong
configuration file with the `portal_auth` property.

In your `kong.conf` file set the property as follows:

```
portal_auth="basic-auth"
```

This will set all Dev Portals to use Basic Authentication by default when initialized.
