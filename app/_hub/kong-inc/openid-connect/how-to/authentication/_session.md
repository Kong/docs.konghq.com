---
title: Session authentication
nav_title: Session
---

## Session auth workflow

The OpenID Connect plugin can issue a session cookie that can be used for further
session authentication. To make OpenID Connect issue a session cookie, you need
to first authenticate with one of the other grants or flows that this plugin supports. 
For example, the [authorization code flow](/hub/kong-inc/openid-connect/how-to/authentication/authorization-code-flow)
demonstrates session authentication when it uses the redirect login action.

The session authentication portion of the flow works like this:

<!--vale off-->
{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client <br>(e.g. mobile app)
    participant kong as API Gateway <br>(Kong)
    participant httpbin as Upstream <br>(backend service,<br> e.g. httpbin)
    activate client
    activate kong
    client->>kong: service with<br>session cookie
    deactivate client
    kong->>kong: load session cookie
    kong->>kong: verify session
    activate httpbin
    kong->>httpbin: request with<br>access token
    httpbin->>kong: response
    deactivate httpbin
    activate client
    kong->>client: response
    deactivate kong
    deactivate client
{% endmermaid %}
<!--vale on-->

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Set up session authentication

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin with session authentication.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: you only need session auth for this flow. 
For the purposes of the demo, the example also enables the
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).

With all of the above in mind, let's test out session authentication with Keycloak. 
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
    - "session"
    - "password"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

## Test the session authentication

1. Request the service with basic authentication credentials (created in the [Keycloak configuration](#prerequisites) step),
   and store the session:
   ```bash
   curl --user <user>:<pass> http://localhost:8000 \
     --cookie-jar example-user
   ```
   
   The cookie should look like this:
   ```http
   HTTP/1.1 200 OK
   Set-Cookie: session=<session-cookie>; Path=/; SameSite=Lax; HttpOnly
   ```

2. Make request with a stored session cookie:
   ```bash
   curl http://localhost:8000 --cookie example-user
   ```

   You should get an HTTP 200 response, and the cookie should appear in the request header:
   ```http
   GET / HTTP/1.1
   Cookie: session=<session-cookie>
   ```

{:.note}
> **Note**: If you want to disable session creation with some grants, you can use the 
[`config.disable_session`](/hub/kong-inc/openid-connect/configuration/#disable_session) configuration parameter.
