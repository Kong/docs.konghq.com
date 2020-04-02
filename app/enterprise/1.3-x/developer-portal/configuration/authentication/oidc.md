---
title: Enable OpenId Connect in the Dev Portal
---

### Introduction

The [OpenID Connect Plugin](/hub/kong-inc/openid-connect/) (OIDC)
allows the Kong Developer Portal to hook into existing authentication setups using third-party
*Identity Providers* (IdP) such as Google, Yahoo, Microsoft Azure AD, etc.

[OIDC](/hub/kong-inc/openid-connect/) must be used with
the `session` method, utilizing cookies for Dev Portal File API requests.

In addition, a configuration object is required to enable OIDC, please refer to the
[Sample Configuration Object](#/sample-configuration-object) section of this
document for more information.

OIDC for the Dev Portal can be enabled in three ways:

- via the [Kong Manager](#enable-oidc-via-kong-manager)
- via the [the command line](#enable-oidc-via-the-command-line)
- via the [the Kong configuration file](#enable-oidc-via-the-kongconf)


### Portal Session Plugin Config

Session Plugin Config does not apply when using OpenID Connect.

### Sample Configuration Object

Below is a sample configuration JSON object for using *Google* as the Identity
Provder:

```
{
  "consumer_by": ["username","custom_id","id"],
  "leeway": 1000,
  "scopes": ["openid","profile","email","offline_access"],
  "logout_query_arg": "logout",
  "client_id": ["<CLIENT-ID>"],
  "login_action": "redirect",
  "logout_redirect_uri": ["http://localhost:8003"],
  "ssl_verify": false,
  "consumer_claim": ["email"],
  "forbidden_redirect_uri": ["http://localhost:8003/unauthorized"],
  "client_secret": ["<CLIENT_SECRET>"],
  "issuer": "https://accounts.google.com/",
  "logout_methods": ["GET"],
  "login_redirect_uri": ["http://localhost:8003"],
  "login_redirect_mode": "query"
}

```

The values above can be replaced with their corresponding values for a custom
OIDC configuration:

  - `<CLIENT_ID>` - Client ID provided by IdP
        * For Example, Google credentials can be found here:
        https://console.cloud.google.com/projectselector/apis/credentials
  - `<CLIENT_SECRET>` - Client secret provided by IdP

If `portal_gui_host` and `portal_api_url` are set to share a domain but differ
in regards to subdomain, `redirect_uri` and `session_cookie_domain` need to be
configured to allow OpenID-Connect to apply the session correctly.

Example:

```
{
  "consumer_by": ["username","custom_id","id"],
  "leeway": 1000,
  "scopes": ["openid","profile","email","offline_access"],
  "logout_query_arg": "logout",
  "client_id": ["<CLIENT_ID>"],
  "login_redirect_uri": ["https://example.portal.com"],
  "login_action": "redirect",
  "logout_redirect_uri": ["https://example.portal.com"],
  "ssl_verify": false,
  "consumer_claim": ["email"],
  "redirect_uri": ["https://exampleapi.portal.com/auth"],
  "session_cookie_domain": ".portal.com",
  "forbidden_redirect_uri": ["https://example.portal.com/unauthorized"],
  "client_secret": ["<CLIENT_SECRET"],
  "issuer": "https://accounts.google.com/",
  "logout_methods": ["GET"],
  "login_redirect_mode": "query"
}

```

### Enable OIDC via Kong Manager

1. Navigate to the Dev Portal's **Settings** page
2. Find **Authentication plugin** under the **Authentication** tab
3. Select **OpenId  Connect** from the drop down
4. Select **Custom** from the **Auth Config (JSON)** field drop down
5. Enter your customized [**Configuration JSON Object**](#/sample-configuration-object)
into the provided text area.
4. Click the **Save Changes** button at the bottom of the form

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable OIDC via the Command Line

To patch a Dev Portal's authentication property directly run:

```
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE NAME> \
  --data "config.portal_auth=openid-connect"
  "config.portal_auth_conf=<REPLACE WITH JSON CONFIG OBJECT>
```

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable OIDC via the Kong.conf

Kong allows for a `default authentication plugin` to be set in the Kong
configuration file with the `portal_auth` property.

In your `kong.conf` file set the property as follows:

```
portal_auth="openid-connect"
```

Then set `portal_auth_conf` property to your
customized [**Configuration JSON Object**](#/sample-configuration-object)

This will set every Dev Portal to use Key Authentication by default when
initialized, regardless of Workspace.
