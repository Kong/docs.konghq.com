---
title: Authorization code flow
nav_title: Authorization code flow
---

## Prerequisites

{% include /md/plugins-hub/oidc-prereqs.md %}

## Authorization code flow

The authorization code flow is the three-legged OAuth/OpenID Connect flow.
The sequence diagram below describes the participants and their interactions
for this usage scenario, including the use of session cookies:

![Authorization code flow diagram](/assets/images/docs/openid-connect/authorization-code-flow.svg)

{:.note}
> If using PKCE, the identity provider *must* contain the `code_challenge_methods_supported` object in the `/.well-known/openid-configuration` issuer discovery endpoint response, as required by [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414.html). If it is not included, the PKCE `code_challenge` query parameter will not be sent.

### Patch the plugin

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step with the following changes:

1. We want to only use the authorization code flow and the session authentication.
2. We want to set the response mode to `form_post` so that authorization codes won't get logged to the access logs.
3. We want to preserve the original request query arguments over the authorization code flow redirection.
3. We want to redirect the client to original request url after the authorization code flow so that
   the `POST` request (because of `form_post`) is turned to the `GET` request, and the browser address bar is updated
   with the original request query arguments.
4. We don't want to include any tokens in the browser address bar.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=authorization_code                         \
  config.auth_methods=session                                    \
  config.response_mode=form_post                                 \
  config.preserve_query_args=true                                \
  config.login_action=redirect                                   \
  config.login_tokens=
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
    "name": "openid-connect",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "auth_methods": [
            "authorization_code",
            "session"
        ],
        "login_action": "redirect",
        "preserve_query_args": true,
        "login_tokens": null
    }
}
```

### Test the authorization code flow

1. Open the service page with some query arguments:
   ```bash
   open http://service.test:8000/?hello=world
   ```
   <img src="/assets/images/docs/openid-connect/authorization-code-flow-1.png">

2. See that the browser is redirected to the Keycloak login page:
   <br><br>
   <img src="/assets/images/docs/openid-connect/authorization-code-flow-2.png">
   <br>
   > You may examine the query arguments passed to Keycloak with the browser developer tools.
3. And finally you will be presented a response from `httpbin.org`:
   <br><br>
   <img src="/assets/images/docs/openid-connect/authorization-code-flow-3.png">

It looks rather simple from the user point of view, but what really happened is
described in the [diagram](#authorization-code-flow) above.