---
title: Migrate from Previous Configurations
badge: enterprise
---

# Breaking changes

As of Gateway v3.6, Kong Manager uses the session management mechanism in the OpenID Connect plugin,
`admin_gui_session_conf` is no longer required when authenticating with OIDC. Instead, session-related
configuration parameters in `admin_gui_auth_conf` (like `session_secret`) will be used.

It is recommended to review your configuration as some session-related parameters in `admin_gui_auth_conf`
have different default values compared to the ones in `admin_gui_session_conf`.

## admin_gui_auth_conf

### scopes

While using the OpenID Connect plugin with Kong Manager, `scopes` now have a default value of
`["openid", "email", "offline_access"]` if not specified.

* `openid`: Essential for OpenID Connect
* `email`: To retrieve user's email address and include it in the ID token
* `offline_access`: Essential refresh tokens to refresh the access tokens and sessions

This parameter can be modified according to needs. However, `"openid"` and `"offline_access"` should
always be included to ensure the OpenID Connect plugin works normally. Also, making sure that `scopes`
contains sufficient scopes for the claim specified by this parameter.

### admin_claim

`admin_claim` is now an optional parameter which has a default value of `["email"]` if not specified.

This parameter is used while looking up for admin's username from the ID token. While configuring this,
making sure that `scopes` contains sufficient scopes for the claim specified by this parameter.

### authenticated_groups_claim

`authenticated_groups_claim` is now an optional parameter which has a default value of `["groups"]`
if not specified.

This parameter is used while looking up for admin's associated groups from the ID token.

### redirect_uri

`redirect_uri` now should be configured to an array of URLs that points to Admin API's authentication
endpoint (e.g., `["http://localhost:8001/auth"]`). Whereas, `redirect_uri` were previously URLs
pointing to Kong Manager (e.g., `["http://localhost:8002"]`).

### login_redirect_uri

`login_redirect_uri` now becomes a **required** parameter to configure the destination after authenticating
with the IdP. It should be always be an array of URLs that points to the Kong Manager
(e.g., `["http://localhost:8002"]`).

### logout_redirect_uri

`logout_redirect_uri` now becomes a **required** parameter to configure the destination after logging
out from the IdP. It should be always be an array of URLs that points to the Kong Manager
(e.g., `["http://localhost:8002"]`).

Previously, Kong Manager will not perform an [RP-initiated logout](https://openid.net/specs/openid-connect-rpinitiated-1_0.html#RPLogout)
from the IdP when a user request to logout. From Gateway v3.6 and onwards, Kong Manager will perform
an RP-initiated logout upon user logout.

## admin_gui_session_conf

As the OpenID Connect plugin has a built-in session management mechanism, `admin_gui_session_conf`
is no longer used while authenticating with OIDC. You should also update your configuration
if you have previously configured the session management via `admin_gui_session_conf` for OIDC.

Additionally, default values of some parameters have been changed. Please check the following for
more details:

### secret

You should now configure this via `admin_gui_auth_conf.session_secret`.

A randomly generated secret will be used if not specified.

### cookie_secure

You should now configure this via `admin_gui_auth_conf.session_cookie_secure`.

Previously, `cookie_secure` will be set to `true` if not specified. However, `admin_gui_auth_conf.session_cookie_secure`
now has a default value of `false`. If you are using HTTPS rather than HTTP, it is recommended to be
enabled to enhance the security.

### cookie_samesite

You should now configure this via `admin_gui_auth_conf.session_cookie_same_site`.

Previously, `cookie_samesite` will be set to `Strict` if not specified. However, `admin_gui_auth_conf.session_cookie_same_site`
now has a default value of `Lax`. If you are using the same domain for the Admin API and Kong Manager,
it is recommended to upgrade it `Strict` to enhance the security.

Learn more about [SameSite in the Cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#samesitesamesite-value)

