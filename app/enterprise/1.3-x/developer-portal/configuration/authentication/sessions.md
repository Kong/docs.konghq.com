---
title: Sessions in the Dev Portal
---

⚠️**Important:** Portal Session Configuration does not apply when using [OpenID Connect](/hub/kong-inc/openid-connect) for Dev Portal authentication. The following information assumes that the Dev Portal is configured with `portal_auth` other than `openid-connect`, for example `key-auth` or `basic-auth`.

## How does the Sessions Plugin work in the Dev Portal?

When a user logs in to the Dev Portal with their credentials, the Sessions Plugin will create a session cookie. The cookie is used for all subsequent requests and is valid to authenticate the user. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended.

The Session configuration is secure by default, which may [require alteration](#session-security) if using HTTP or different domains for [portal_api_url](/enterprise/{{page.kong_version}}/developer-portal/networking/#portal_api_url) and [portal_gui_host](/enterprise/{{page.kong_version}}/developer-portal/networking/#portal_gui_host). Even if an attacker were to obtain a stale cookie, it would not benefit them since the cookie is encrypted. The encrypted session data may be stored either in Kong or the cookie itself.

## Configuration to Use the Sessions Plugin with the Dev Portal

To enable sessions authentication, configure the following:

```
portal_auth = <set to desired auth type>
portal_session_conf = {
    "secret":"<SET_SECRET>",
    "cookie_name":"<SET_COOKIE_NAME>",
    "storage":"kong",
    "cookie_lifetime":<NUMBER_OF_SECONDS_TO_LIVE>,
    "cookie_renew":<NUMBER_OF_SECONDS_LEFT_TO_RENEW>
    "cookie_secure":<SET_DEPENDING_ON_PROTOCOL>
    "cookie_samesite":"<SET_DEPENDING_ON_DOMAIN>"
}
```

* `"cookie_name":"<SET_COOKIE_NAME>"`: The name of the cookie
  * For example, `"cookie_name":"portal_cookie"`
* `"secret":"<SET_SECRET>"`: The secret used in keyed HMAC generation. Although
  the **Session Plugin's** default is a random string, the `secret` _must_ be
  manually set for use with the Dev Portal since it must be the same across all
  Kong workers/nodes.
* `"storage":"kong"`: Where session data is stored. This value _must_ be set to `kong` for use with the Dev Portal.
* `"cookie_lifetime":<NUMBER_OF_SECONDS_TO_LIVE>`: The duration (in seconds) that the session will remain open; 3600 by    default.
* `"cookie_renew":<NUMBER_OF_SECONDS_LEFT_TO_RENEW>`: The duration (in seconds) of a session remaining at which point
   the Plugin renews the session; 600 by default.
* `"cookie_secure":<SET_DEPENDING_ON_PROTOCOL>`: `true` by default. See [Session Security](#session-security) for
    exceptions.
* `"cookie_samesite":"<SET_DEPENDING_ON_DOMAIN>"`: `"Strict"` by default. See [Session Security](#session-security) for
    exceptions.

⚠️**Important:**
*The following properties must not be altered from default for use with the Dev Portal:*
* `logout_methods`
* `logout_query_arg`
* `logout_post_arg`

For detailed descriptions of each configuration property, learn more in the [Session Plugin documentation](/enterprise/{{page.kong_version}}/plugins/session).

## Session Security

The Session configuration is secure by default, so the cookie uses the [Secure, HttpOnly](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies), and [SameSite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies) directives.

⚠️**Important:** The following properties must be altered depending on the protocol and domains in use:
* If using HTTP instead of HTTPS: `"cookie_secure": false`
* If using different domains for [portal_api_url](/enterprise/{{page.kong_version}}/developer-portal/networking/#portal_api_url) and [portal_gui_host](/enterprise/{{page.kong_version}}/developer-portal/networking/#portal_gui_host): `"cookie_samesite": "off"`

## Example Configurations

If using HTTPS and hosting Dev Portal API and the Dev Portal GUI from the same domain, the following configuration could be used for Basic Auth:

```
portal_auth = basic-auth
portal_session_conf = {
    "cookie_name":"$4m04$"
    "secret":"change-this-secret"
    "storage":"kong"
}
```

In testing, if using HTTP, the following configuration could be used instead:

```
portal_auth = basic-auth
portal_session_conf = {
    "cookie_name":"04tm34l"
    "secret":"change-this-secret"
    "storage":"kong"
    "cookie_secure":false
}
```
