---
title: Debugging
nav_title: Debugging
---

## Prerequisites

{% include /md/plugins-hub/oidc-prereqs.md %}

## Debugging

The OpenID Connect plugin is complex, integrating with third-party identity providers can present challenges. If you have
issues with the plugin or integration, try the following:

1. Set Kong [log level](/gateway/latest/reference/configuration/#log_level) to `debug`, and check the Kong `error.log` (you can filter it with `openid-connect`)
   ```bash
   KONG_LOG_LEVEL=debug kong restart
   ```
2. Set the Kong OpenID Connect plugin to display errors:
   ```json
   {
       "config": {
           "display_errors": true
       }
   }
   ```
3. Disable the Kong OpenID Connect plugin verifications and see if you get further, just for debugging purposes:
   ```json
   {
       "config": {
           "verify_nonce": false,
           "verify_claims": false,
           "verify_signature": false
       }
   }
   ```
4. See what kind of tokens the Kong OpenID Connect plugin gets:
   ```json
   {
       "config": {
           "login_action": "response",
           "login_tokens": [ "tokens" ],
           "login_methods": [
               "password",
               "client_credentials",
               "authorization_code",
               "bearer",
               "introspection",
               "userinfo",
               "kong_oauth2",
               "refresh_token",
               "session"
           ]
       }
   }
   ```

With session related issues, you can try to store the session data in `Redis` or `memcache` as that will make the session
cookie much smaller. It is rather common that big cookies do cause issues. You can also enable session
compression.

Also try to eliminate indirection as that makes it easier to find out where the problem is. By indirection, we
mean other gateways, load balancers, NATs, and such in front of Kong. If there is such, you may look at using:

- [port maps](/gateway/latest/reference/configuration/#port_maps)
- `X-Forwarded-*` headers