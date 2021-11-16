---
title: Sessions in Kong Manager
badge: enterprise
---

## How does the Sessions Plugin work in Kong Manager?

When a user logs in to Kong Manager with their credentials, the Sessions Plugin
will create a session cookie. The cookie is used for all subsequent requests and
is valid to authenticate the user. The session has a limited duration and renews
at a configurable interval, which helps prevent an attacker from obtaining and
 using a stale cookie after the session has ended.

The Session configuration is secure by default, which may
[require alteration](#session-security) if using HTTP or different domains for
the Admin API and Kong Manager. Even if an attacker were to obtain a stale
cookie, it would not benefit them since the cookie is encrypted. The encrypted
session data may be stored either in Kong or the cookie itself.

## Configuration to Use the Sessions Plugin with Kong Manager

To enable sessions authentication, configure the following:

```
enforce_rbac = on
admin_gui_auth = <set to desired auth type>
admin_gui_session_conf = {
    "secret":"<SET_SECRET>",
    "cookie_name":"<SET_COOKIE_NAME>",
    "storage":"<SET_STORAGE>",
    "cookie_lifetime":<NUMBER_OF_SECONDS_TO_LIVE>,
    "cookie_renew":<NUMBER_OF_SECONDS_LEFT_TO_RENEW>
    "cookie_secure":<SET_DEPENDING_ON_PROTOCOL>
    "cookie_samesite":"<SET_DEPENDING_ON_DOMAIN>"
}
```

* `"cookie_name":"<SET_COOKIE_NAME>"`: The name of the cookie
  * For example, `"cookie_name":"kong_cookie"`
* `"secret":"<SET_SECRET>"`: The secret used in keyed HMAC generation. Although
  the **Session Plugin's** default is a random string, the `secret` _must_ be
  manually set for use with Kong Manager since it must be the same across all
  Kong workers/nodes.
* `"storage":"<SET_STORAGE>"`: Where session data is stored. It is `"cookie"` by default, but may be more secure if set to `"kong"` since access to the database would be required.
* `"cookie_lifetime":<NUMBER_OF_SECONDS_TO_LIVE>`: The duration (in seconds) that the session will remain open; 3600 by    default.
* `"cookie_renew":<NUMBER_OF_SECONDS_LEFT_TO_RENEW>`: The duration (in seconds) of a session remaining at which point
   the Plugin renews the session; 600 by default.
* `"cookie_secure":<SET_DEPENDING_ON_PROTOCOL>`: `true` by default. See [Session Security](#session-security) for
    exceptions.
* `"cookie_samesite":"<SET_DEPENDING_ON_DOMAIN>"`: `"Strict"` by default. See [Session Security](#session-security) for
    exceptions.


{:.important}
> **Important:** The following properties must **not** be altered from default for use with Kong Manager:*
* `logout_methods`
* `logout_query_arg`
* `logout_post_arg`

For detailed descriptions of each configuration property, learn more in the
[Session Plugin documentation](/hub/kong-inc/session).

## Session Security

The Session configuration is secure by default, so the cookie uses the
[Secure, HttpOnly](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies),
and [SameSite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies)
directives.

The following properties must be altered depending on the protocol and domains in use:
* If using HTTP instead of HTTPS: `"cookie_secure": false`
* If using different domains for the Admin API and Kong Manager: `"cookie_samesite": "off"`

{:.important}
> **Important:** </strong>Sessions are not invalidated when a user logs out if `"storage": "cookie"` (the default) is used. In that case, the cookie is deleted client-side. Only when session data is stored server-side with `"storage": "kong"` set is the session actively invalidated.


## Example Configurations

If using HTTPS and hosting Kong Manager and the Admin API from the same domain,
the following configuration could be used for Basic Auth:

```
enforce_rbac = on
admin_gui_auth = basic-auth
admin_gui_session_conf = {
    "cookie_name":"$4m04$"
    "secret":"change-this-secret"
    "storage":"kong"
}
```

In testing, if using HTTP, the following configuration could be used instead:

```
enforce_rbac = on
admin_gui_auth = basic-auth
admin_gui_session_conf = {
    "cookie_name":"04tm34l"
    "secret":"change-this-secret"
    "storage":"kong"
    "cookie_secure":false
}
```
