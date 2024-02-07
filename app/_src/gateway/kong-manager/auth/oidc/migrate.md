---
title: Migrate from Previous Configurations
badge: enterprise
---

As of Gateway v3.6, Kong Manager uses the session management mechanism in the OpenID Connect plugin.
`admin_gui_session_conf` is no longer required when authenticating with OIDC. Instead, session-related
configuration parameters are set in `admin_gui_auth_conf` (like `session_secret`).

We recommend reviewing your configuration, as some session-related parameters in `admin_gui_auth_conf`
have different default values compared to the ones in `admin_gui_session_conf`.

<!-- vale off -->
## admin_gui_auth_conf
<!-- vale on -->

See the following summary of changes to attributes of `admin_gui_auth_conf`, and follow the individual links for further information:

Parameter | Old behavior | New behavior 
---|---|---|---|---
[`scopes`](#scopes) | Old default: `["openid", "profile", "email"]` | New default: `["openid", "email", "offline_access"]` 
[`admin_claim`](#admin_claim) | Required | Optional (Default: `"email"`)
[`authenticated_groups_claim`](#authenticated_groups_claim) | Required | Optional (Default: `["groups"]`)
[`redirect_uri`](#redirect_uri) | Takes an array of URLs pointing to Kong Manager | Takes an array of URLs pointing to the Admin API's `/auth` endpoint
[`login_redirect_uri`](#login_redirect_uri) | Optional | Required 
[`logout_redirect_uri`](#logout_redirect_uri) | Optional | Required

<!-- vale off -->
### scopes
<!-- vale on -->

While using the OpenID Connect plugin with Kong Manager, `scopes` now have a default value of
`["openid", "email", "offline_access"]` if not specified.

* `openid`: Essential for OpenID Connect.
* `email`: Retrieves the user's email address and includes it in the ID token.
* `offline_access`: Essential refresh tokens to refresh the access tokens and sessions.

This parameter can be modified according to your needs. However, `"openid"` and `"offline_access"` should
always be included to ensure the OpenID Connect plugin works normally. Also, make sure that `scopes`
contains sufficient scopes for the claim specified by this parameter (for example, `"email"` in the default scopes).

<!-- vale off -->
### admin_claim
<!-- vale on -->

`admin_claim` is now an optional parameter. If not set, it defaults to `"email"`.

This parameter is used while looking up the admin's username from the ID token. When configuring this setting,
make sure that `scopes` contains sufficient scopes for the claim specified by this parameter.

<!-- vale off -->
### authenticated_groups_claim
<!-- vale on -->

`authenticated_groups_claim` is now an optional parameter. If not set, it defaults to `["groups"]`.

This parameter is used while looking up the admin's associated groups from the ID token.

<!-- vale off -->
### redirect_uri
<!-- vale on -->

`redirect_uri` now should be configured as an array of URLs that points to Admin API's authentication
endpoint `<ADMIN_API>/auth` (for example,`["http://localhost:8001/auth"]`). 
Previously, `redirect_uri` was a list of URLs
pointing to Kong Manager (for example,`["http://localhost:8002"]`).

Users are recommended to update the client/application settings in their IdP to ensure that `<ADMIN_API>/auth`
(for example,`http://localhost:8001/auth`) is in the allow list for redirect URIs.

<!-- vale off -->
### login_redirect_uri
<!-- vale on -->

`login_redirect_uri` is now a **required** parameter to configure the destination after authenticating
with the IdP. It should be always be an array of URLs that points to the Kong Manager
(for example, `["http://localhost:8002"]`).

<!-- vale off -->
### logout_redirect_uri
<!-- vale on -->

`logout_redirect_uri` is now a **required** parameter to configure the destination after logging
out from the IdP. It should be always be an array of URLs that points to the Kong Manager
(for example, `["http://localhost:8002"]`).

Previously, Kong Manager didn't perform an [RP-initiated logout](https://openid.net/specs/openid-connect-rpinitiated-1_0.html#RPLogout)
from the IdP when a user request to logout. From Gateway v3.6 and onwards, Kong Manager will perform
an RP-initiated logout upon user logout.

<!-- vale off -->
## admin_gui_session_conf
<!-- vale on -->

As the OpenID Connect plugin now has a built-in session management mechanism, `admin_gui_session_conf`
is no longer used while authenticating with OIDC. You should also update your configuration
if you have previously configured session management via `admin_gui_session_conf` for OIDC.

Additionally, the default values of some parameters have been changed. 
See the following for more details:

Old parameter name and location | New parameter name and location | Old default | New default
---|---|---|---|---
[`admin_gui_session_conf.secret`](#secret) | `admin_gui_auth_conf.session_secret` | -- | -- |
[`admin_gui_session_conf.cookie_secure`](#cookie_secure) | `admin_gui_auth_conf.session_cookie_secure`| `true` | `false` | 
[`admin_gui_session_conf.cookie_samesite`](#cookie_samesite) | `admin_gui_auth_conf.session_cookie_same_site` | `Strict` | `Lax` |

<!-- vale off -->
### secret
<!-- vale on -->

You should now configure this via `admin_gui_auth_conf.session_secret`.

If not set, {{site.base_gateway}} will randomly generate a secret.

<!-- vale off -->
### cookie_secure
<!-- vale on -->

You should now configure this via `admin_gui_auth_conf.session_cookie_secure`.

Previously, `cookie_secure` was set to `true` if not specified. However, `admin_gui_auth_conf.session_cookie_secure`
now has a default value of `false`. 
If you are using HTTPS rather than HTTP, we recommend enabling this option to enhance security.

<!-- vale off -->
### cookie_samesite
<!-- vale on -->

You should now configure this via `admin_gui_auth_conf.session_cookie_same_site`.

Previously, `cookie_samesite` was set to `Strict` if not specified. However, `admin_gui_auth_conf.session_cookie_same_site`
now has a default value of `Lax`. If you are using the same domain for the Admin API and Kong Manager,
we recommend upgrading this setting to `Strict` to enhance security.

Learn more about [SameSite in the Cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#samesitesamesite-value).

