---
title: Sessions in Kong Manager
book: admin_gui
---

## How does the Sessions Plugin work in Kong Manager?

When a user logs in to Kong Manager with their credentials, the Sessions Plugin will create a session cookie. The cookie is used for all subsequent requests and is valid to authenticate the user. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended. 

Even if an attacker were to obtain a stale cookie, it would not benefit them since the cookie is encrypted. The encrypted session data may be stored either in Kong or the cookie itself. By default, the cookie uses the [Secure, HttpOnly](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies), and [SameSite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies) directives.

**Note:** In order to enable SameSite, Kong Manager and the Admin API must 
share the same host.

## Configuration to Use the Sessions Plugin with Kong Manager

To enable sessions authentication, configure the following:

```
enforce_rbac = on
admin_gui_auth = <set to desired auth type>
admin_gui_session_conf = {
    "cookie_name":"<SET_COOKIE_NAME>", 
    "secret":"<SET_SECRET>", 
    "storage":"kong", 
    "cookie_lifetime":<NUMBER_OF_SECONDS_TO_LIVE>, 
    "cookie_renew":<NUMBER_OF_SECONDS_LEFT_TO_RENEW>
}
```

* `"cookie_name":"<SET_COOKIE_NAME>"`: The name of the cookie
  * For example, `"cookie_name":"kong_cookie"`
* `"secret":"<SET_SECRET>"`: The secret used in keyed HMAC generation. Although 
  the **Session Plugin's** default is a random string, the `secret` _must_ be 
  manually set for use with Kong Manager since it must be the same across all 
  Kong workers/nodes.