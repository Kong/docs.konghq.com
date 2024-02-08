---
title: Authorization code flow
nav_title: Authorization code flow
---

## Authorization code flow

The authorization code flow is the three-legged OAuth/OpenID Connect flow.
The sequence diagram below describes the participants and their interactions
for this usage scenario, including the use of session cookies:

<!--vale off-->
{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client <br>(e.g. mobile app)
    participant kong as API Gateway <br>(Kong)
    participant idp as IDP <br>(e.g. Keycloak)
    participant httpbin as Upstream <br>(backend service,<br> e.g. httpbin)
    activate client
    activate kong
    client->>kong: HTTP request
    kong->>client: Redirect mobile app to IDP 
    deactivate kong
    activate idp
    client->>idp: Request access and authentication<br>with client parameter
    Note left of idp: /auth<br>response_type=code,<br>scope=openid
    idp->>client: Login (ask for consent)
    client->>idp: /auth with user credentials (grant consent)
    idp->>client: Return authorization code and redirect
    Note left of idp: short-lived authcode
    activate kong
    client->>kong: HTTP redirect with authorization code
    deactivate client
    kong->>kong: Verify authorization code flow
    kong->>idp: Request ID token, access token, and refresh token
    Note left of idp: /token<br>client_id:client_secret<br>authcode
    idp->>idp: Authenticate client (Kong)<br>and validate authcode
    idp->>kong: Returns tokens
    Note left of idp: ID token, access token, and refresh token
    deactivate idp
    kong->>kong: Validate tokens
    Note right of kong: Cryptographic<br>signature validation,<br>expiry check<br>(OIDC Standard JWT validation)
    activate client
    kong->>client: Redirect with session cookie<br>having session ID (SID)
    Note left of kong: sid: cryptorandom bytes <br>(128 bits)<br>& HMAC protected
    client->>kong: Authenticated request with session cookie
    deactivate client
    kong->>kong: Verify session cookie
    Note right of kong: Retrieve encrypted tokens<br>from session store (redis)
    activate httpbin
    kong->>httpbin: Backend service request with tokens
    Note right of idp: Access token and ID token
    httpbin->>kong: Backend service response
    deactivate httpbin
    activate client
    kong->>client: HTTP response
    deactivate kong
    deactivate client
{% endmermaid %}
<!--vale on-->

{:.note}
> If using PKCE, the identity provider *must* contain the `code_challenge_methods_supported` object in the `/.well-known/openid-configuration` issuer discovery endpoint response, as required by [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414.html). If it is not included, the PKCE `code_challenge` query parameter will not be sent.

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Set up the authorization code flow

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

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

2. The browser should be redirected to the Keycloak login page.

   You may examine the query arguments passed to Keycloak with the browser developer tools.

3. And finally you will be presented a response from `httpbin.org` that looks something like this:

   ```json
   {
    "args": {
        "hello": "world"
    },
    "headers": {
        "Authorization": "Bearer <access-token>",
    },
    "method": "GET",
    "url": "http://service.test/anything?hello=world"
   }
   ```

It looks rather simple from the user point of view, but what really happened is
described in the [diagram](#authorization-code-flow) above.