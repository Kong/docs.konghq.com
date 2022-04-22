---
title: Enable OpenID Connect in the Dev Portal
---

### Introduction

The [OpenID Connect Plugin](/hub/kong-inc/openid-connect/) (OIDC)
allows the Kong Developer Portal to hook into existing authentication setups using third-party
*Identity Providers* (IdP) such as Google, Okta, Microsoft Azure AD,
[Curity](/enterprise/latest/plugins/oidc-curity/#kong-dev-portal-authentication), etc.

[OIDC](/hub/kong-inc/openid-connect/) must be used with
the `session` method, utilizing cookies for Dev Portal File API requests.

In addition, a configuration object is required to enable OIDC. Refer to the
[Sample Configuration Object](#/sample-configuration-object) section of this
document for more information.

**Note:** The Dev Portal does not automatically create developer accounts on login via OIDC.
A developer account matching the `consumer_claim` configuration parameter has to be
created and approved (if auto approve is not enabled) beforehand.

OIDC for the Dev Portal can be enabled in one of the following ways:

- [Kong Manager](#enable-oidc-using-kong-manager)
- [Kong Admin API (command line)](#enable-oidc-using-the-command-line)
- [The Kong configuration file](#enable-oidc-using-kongconf)


### Portal Session Plugin Config

Session Plugin Config does not apply when using OpenID Connect.

### Sample Configuration Object

Below is a sample configuration JSON object for using *Google* as the Identity
Provider:

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

The placeholders above should be replaced with your actual values:

  - `<CLIENT_ID>` - Client ID provided by IdP
  - `<CLIENT_SECRET>` - Client secret provided by IdP

See the [documentation of the OpenID Connect plugin](/hub/kong-inc/openid-connect/)
for more information.

**Important:** The `redirect_uri` needs to be configured as an allowed URI in the IdP.
If not set explicitly in the configuration object, the URI default is
`http://localhost:8004/<WORKSPACE_NAME>/auth`.

If `portal_gui_host` and `portal_api_url` are set to share a domain but differ
with regard to subdomain, `redirect_uri` and `session_cookie_domain` need to be
configured to allow OpenID Connect to apply the session correctly.

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

### Enable OIDC using Kong Manager

1. Navigate to the Dev Portal's **Settings** page.
2. Find **Authentication plugin** under the **Authentication** tab.
3. Select **OpenId  Connect** from the drop down.
4. Select **Custom** from the **Auth Config (JSON)** field drop down.
5. Enter your customized [**Configuration JSON Object**](#/sample-configuration-object)
into the provided text area.
4. Click **Save Changes**.

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable OIDC using the Command Line

You can use the Kong Admin API to set up Dev Portal Authentication.
To patch a Dev Portal's authentication property directly, run:

```
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE NAME> \
  --data "config.portal_auth=openid-connect"
  "config.portal_auth_conf=<REPLACE WITH JSON CONFIG OBJECT>
```

>**Warning** When Dev Portal Authentication is enabled, content files will remain unauthenticated until a role is applied to them. The exception to this is `settings.txt` and `dashboard.txt` which begin with the `*` role. Please visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions">Developer Roles and Content Permissions</a> section for more info.

### Enable OIDC using kong.conf

Kong allows for a `default authentication plugin` to be set in the Kong
configuration file with the `portal_auth` property.

In your `kong.conf` file, set the property as follows:

```
portal_auth="openid-connect"
```

Then set the `portal_auth_conf` property to your
customized [**Configuration JSON Object**](#sample-configuration-object).

This will set every Dev Portal to use OIDC by default when initialized, regardless of Workspace.
