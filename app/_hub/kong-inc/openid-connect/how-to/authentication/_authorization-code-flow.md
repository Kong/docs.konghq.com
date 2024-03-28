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
> If using PKCE, the identity provider *must* contain the `code_challenge_methods_supported` object 
in the `/.well-known/openid-configuration` issuer discovery endpoint response, as required by 
[RFC 8414](https://www.rfc-editor.org/rfc/rfc8414.html).
If it is not included, the PKCE `code_challenge` query parameter will not be sent.

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Set up the authorization code flow

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth methods: authorization code flow and session authentication.
* Response mode: set to `form_post` so that authorization codes won't get logged to the access logs.
* We want to preserve the original request query arguments over the authorization code flow redirection.
* We want to redirect the client to original request url after the authorization code flow so that
   the `POST` request (because of `form_post`) is turned to the `GET` request, and the browser address 
   bar is updated with the original request query arguments.
* We don't want to include any tokens in the browser address bar.

With all of the above in mind, let's test out the authorization code flow with Keycloak. 
Enable the OpenID Connect plugin on the `openid-connect` service:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/openid-connect
name: openid-connect
config:
  issuer: "http://keycloak.test:8080/auth/realms/master"
  client_id: "kong"
  client_auth: "private_key_jwt"
  auth_methods:
    - "authorization_code"
    - "session"
  response_mode: "form_post"
  preserve_query_args: true
  login_action: "redirect"
  login_tokens: null
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

## Test the authorization code flow

At this point you have created a service, routed traffic to the service, and 
enabled the OpenID Connect plugin on the service. You can now test the authorization code flow.

1. Check the discovery cache: 

    ```sh
    curl -i -X GET http://localhost:8001/openid-connect/issuers
    ```

    It should contain Keycloak OpenID Connect discovery document and the keys.

1. Open the service page with some query arguments:

   ```bash
   open http://localhost:8000/?hello=world
   ```

2. The browser should be redirected to the Keycloak login page.

   You can examine the query arguments passed to Keycloak with the browser's developer tools.

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
    "url": "http://localhost:8001/anything?hello=world"
   }
   ```

It looks rather simple from the user point of view, but what really happened is
described in the [diagram](#authorization-code-flow) above.