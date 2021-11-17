---
name: Session
publisher: Kong Inc.
version: 2.4.4-x

desc: Support sessions for Kong Authentication Plugins.
description: |
  The Kong Session Plugin can be used to manage browser sessions for APIs proxied
  through the Kong API Gateway. It provides configuration and management for
  session data storage, encryption, renewal, expiry, and sending browser cookies.
  It is built using
  <a href="https://github.com/bungle/lua-resty-session">lua-resty-session</a>.

  For information about configuring and using the Sessions plugin with the Dev
  Portal, see [Sessions in the Dev Portal](/gateway/latest/developer-portal/configuration/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-the-dev-portal).

type: plugin
categories:
  - authentication

source_url: https://github.com/Kong/kong-plugin-session

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x     
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
  enterprise_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x


params:
  name: session
  service_id: true
  route_id: true
  consumer_id: false
  dbless_compatible: partially
  dbless_explanation: |
    `config.storage` must be set to `cookie`. The `kong` strategy uses
    a database, and is not supported. The plugin currently lacks checks
    for this invalid configuration in DB-less mode.
  config:
    - name: secret
      required: false
      default: random number generated from `kong.utils.random_string`
      value_in_examples: opensesame
      datatype: string
      description: The secret that is used in keyed HMAC generation.​
    - name: cookie_name
      required: false
      default: '`session`'
      datatype: string
      description: The name of the cookie.
    - name: cookie_lifetime
      required: false
      default: 3600
      datatype: number
      description: The duration in seconds that the session will remain open.
    - name: cookie_idletime
      required: false
      datatype: number
      description: |
        The cookie idle time (in seconds); if a cookie is not used for this time
        period, the session becomes invalid. This value is not set by default,
        meaning idle time checks are disabled.
    - name: cookie_renew
      required: false
      default: 600
      datatype: number
      description: The remaining duration in seconds of a session at which point the Plugin renews the session.
    - name: cookie_path
      required: false
      default: '/'
      datatype: string
      description: The resource in the host where the cookie is available.
    - name: cookie_domain
      required: false
      default: Set using Nginx variable host, but may be overridden
      datatype: string
      description: The domain with which the cookie is intended to be exchanged.
    - name: cookie_samesite
      required: false
      default: 'Strict'
      datatype: string
      description: |
        Determines whether and how a cookie may be sent with cross-site requests. `Strict`:
        The browser will send cookies only if the request originated from the website that set the cookie.
        `Lax`: Same-site cookies are withheld on cross-domain subrequests, but will be sent when a user navigates
        to the URL from an external site, for example, by following a link. `None` or `off`: Disables
        the same-site attribute so that a cookie may be sent with cross-site requests. `None` requires
        the Secure attribute (`cookie_secure`) in latest browser versions. For more info, see the
        [SameSite cookies docs on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite).'
    - name: cookie_httponly
      required: false
      default: true
      datatype: boolean
      description: |
        Applies the `HttpOnly` tag so that the cookie is sent only to a server. See the
        [Restrict access to cookies docs on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Restrict_access_to_cookies).
    - name: cookie_secure
      required: false
      default: true
      datatype: boolean
      description: |
        Applies the Secure directive so that the cookie may be sent to the server only with an encrypted
        request over the HTTPS protocol. See the
        [Restrict access to cookies docs on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Restrict_access_to_cookies).
    - name: cookie_discard
      required: false
      default: 10
      datatype: number
      description: The duration in seconds after which an old session’s TTL is updated that an old cookie is discarded.
    - name: storage
      required: false
      default: 'cookie'
      datatype: string
      description: |
        Determines where the session data is stored. `kong`: Stores encrypted session data into Kong's current database
        strategy (e.g. Postgres, Cassandra); the cookie will not contain any session data. `cookie`: Stores encrypted
        session data within the cookie itself.
    - name: logout_methods
      required: false
      default: '[`"POST"`, `"DELETE"`]'
      datatype: array of string elements
      description: |
        The methods that may be used to end sessions: POST, DELETE, GET.
    - name: logout_query_arg
      required: false
      default: session_logout
      datatype: string
      description: The query argument passed to logout requests.
    - name: logout_post_arg
      required: false
      default: session_logout
      datatype: string
      description: The POST argument passed to logout requests. Do not change this property.
---

## Usage

The Kong Session plugin can be configured globally or with an entity (e.g., Service, Route)
and is always used in conjunction with another Kong Authentication [Plugin]. This
plugin is intended to work similarly to the [multiple authentication] setup.

After the Kong Session plugin is enabled in conjunction with an Authentication plugin,
it runs prior to the credential verification. If no session is found, then the
authentication plugin runs again and credentials are checked normally. If the
credential verification is successful, then the Session plugin creates a new
session for usage with subsequent requests.

When a new request comes in and a session is already present, then the Kong Session
plugin attaches the `ngx.ctx` variables to let the authentication
plugin know that authentication has already occurred via session validation.
As this configuration is a logical OR scenario, and it's desired that anonymous
access be forbidden, you should configure the [Request Termination](https://docs.konghq.com/hub/kong-inc/request-termination/) plugin on an anonymous consumer. Failure to do so allows unauthorized
requests. For more information, see [multiple authentication](https://docs.konghq.com/gateway/latest/configure/auth/#multiple-authentication).

### Set up With a Database

For usage with [Key Auth] plugin

1. Create an example Service and a Route

   Issue the following cURL request to create `example-service` pointing to
   mockbin.org, which echoes the request:

   ```bash
   $ curl -i -X POST \
     --url http://localhost:8001/services/ \
     --data 'name=example-service' \
     --data 'url=http://mockbin.org/request'
   ```

   Add a route to the Service:

   ```bash
   $ curl -i -X POST \
     --url http://localhost:8001/services/example-service/routes \
     --data 'paths[]=/sessions-test'
   ```

   The URL `http://localhost:8000/sessions-test` now echoes whatever is being
   requested.

1. Configure the key-auth plugin for the Service

   Issue the following cURL request to add the key-auth plugin to the Service:

   ```bash
   $ curl -i -X POST \
     --url http://localhost:8001/services/example-service/plugins/ \
     --data 'name=key-auth'
   ```

   Be sure to note the created plugin `id`, which is needed later.

1. Verify that the key-auth plugin is properly configured

   Issue the following cURL request to verify that the [key-auth][key-auth]
   plugin is properly configured on the Service:

   ```bash
   $ curl -i -X GET \
     --url http://localhost:8000/sessions-test
   ```

   Since the required header or parameter `apikey` is not specified, and
   anonymous access is not yet enabled, the response should be `401 Unauthorized`.

1. Create a Consumer and an anonymous Consumer

   Every request proxied and authenticated by Kong must be associated with a
   Consumer. You can now create a Consumer named `anonymous_users` by issuing
   the following request:

   ```bash
   $ curl -i -X POST \
     --url http://localhost:8001/consumers/ \
     --data "username=anonymous_users"
   ```

   Be sure to note the Consumer `id`, which is needed later.

   Now create a consumer that authenticates via sessions:

   ```bash
   $ curl -i -X POST \
     --url http://localhost:8001/consumers/ \
     --data "username=fiona"
   ```

1. Provision `key-auth` credentials for your Consumer

   ```bash
   $ curl -i -X POST \
     --url http://localhost:8001/consumers/fiona/key-auth/ \
     --data 'key=open_sesame'
   ```

1. Enable anonymous access

   You can now re-configure the key-auth plugin to permit anonymous access by
   issuing the following request (**replace the uuids below with the `id` value
   from previous steps**):

   ```bash
   $ curl -i -X PATCH \
     --url http://localhost:8001/plugins/<your-key-auth-plugin-id> \
     --data "config.anonymous=<anonymous_consumer_id>"
   ```

1. Add the Kong Session plugin to the service

   ```bash
   $ curl -X POST http://localhost:8001/services/example-service/plugins \
       --data "name=session"  \
       --data "config.storage=kong" \
       --data "config.cookie_secure=false"
   ```

   > Note: cookie_secure is true by default, and should always be true, but is set to
   > false for the sake of this demo to avoid using HTTPS.

1. Add the Request Termination plugin

   To disable anonymous access to only allow users access via sessions or via
   authentication credentials, enable the Request Termination plugin.

   ```bash
   $ curl -X POST http://localhost:8001/services/example-service/plugins \
       --data "name=request-termination"  \
       --data "config.status_code=403" \
       --data "config.message=So long and thanks for all the fish!" \
       --data "consumer.id=<anonymous_consumer_id>"
   ```

### Set up Without a Database

Add all these to the declarative config file:

```yaml
services:
  - name: example-service
    url: http://mockbin.org/request

routes:
  - service: example-service
    paths: ['/sessions-test']

consumers:
  - username: anonymous_users
    # manually set to fixed uuid in order to use it in key-auth plugin
    id: 81823632-10c0-4098-a4f7-31062520c1e6
  - username: fiona

keyauth_credentials:
  - consumer: fiona
    key: open_sesame

plugins:
  - name: key-auth
    service: example-service
    config:
      # using the anonymous consumer fixed uuid (can't use the username)
      anonymous: 81823632-10c0-4098-a4f7-31062520c1e6
      # cookie_secure is true by default, and should always be true,
      # but is set to false for the sake of this demo in order to avoid using HTTPS.
      cookie_secure: false
  - name: session
    config:
      storage: kong
      cookie_secure: false
  - name: request-termination
    service: example-service
    consumer: anonymous_users
    config:
      status_code: 403
      message: 'So long and thanks for all the fish!'
```

### Verification

1. Check that Anonymous requests are disabled:

   ```bash
     $ curl -i -X GET \
       --url http://localhost:8000/sessions-test
   ```

   Should return `403`.

2. Verify that a user can authenticate via sessions

   ```bash
   $ curl -i -X GET \
     --url http://localhost:8000/sessions-test?apikey=open_sesame
   ```

   The response should now have the `Set-Cookie` header. Make sure that this
   cookie works.

   If cookie looks like this:

   ```
   Set-Cookie: session=emjbJ3MdyDsoDUkqmemFqw..|1544654411|4QMKAE3I-jFSgmvjWApDRmZHMB8.; Path=/; SameSite=Strict; HttpOnly
   ```

   Use it like this:

   ```bash
     $ curl -i -X GET \
       --url http://localhost:8000/sessions-test \
       -H "cookie:session=emjbJ3MdyDsoDUkqmemFqw..|1544654411|4QMKAE3I-jFSgmvjWApDRmZHMB8."
   ```

   This request should succeed and the `Set-Cookie` response header does not appear
   until the renewal period.

3. Navigate to `http://localhost:8000/sessions-test`

   If the cookie is attached to the browser session, it should return the
   code `403` and the message “So long and thanks for all the fish!”.

4. Navigate to `http://localhost:8000/sessions-test?apikey=open_sesame`

   It should return `200` and authenticated via `key-auth` key query param.

5. Navigate to `http://localhost:8000/sessions-test`

   It can now use the session cookie that is granted by the Session plugin.

### Defaults

By default, the Kong Session plugin favors security using a `Secure`, `HTTPOnly`,
`Samesite=Strict` cookie. `cookie_domain` is automatically set using Nginx
variable host, but can be overridden.

### Session Data Storage

The session data can be stored in the cookie itself (encrypted) `storage=cookie`,
or inside [Kong](#kong-storage-adapter). The session data stores these context
variables:

```
ngx.ctx.authenticated_consumer.id
ngx.ctx.authenticated_credential.id
ngx.ctx.authenticated_groups
```

The plugin also sets a `ngx.ctx.authenticated_session` for communication between
the `access` and `header_filter` phases in the plugin.

### Groups

Authenticated groups are stored on `ngx.ctx.authenticated_groups` from other
authentication plugins and the session plugin will store them in the data of
the current session. Since the session plugin runs before authentication
plugins, it also sets `authenticated_groups` associated headers.

## Kong Storage Adapter

The Session plugin extends the functionality of [lua-resty-session] with its own
session data storage adapter when `storage=kong`. This stores encrypted
session data into the current database strategy (e.g., Postgres, Cassandra, etc.)
and the cookie does not contain any session data. Data stored in the database is
encrypted and the cookie contains only the session id, expiration time, and
HMAC signature. Sessions use the built-in Kong DAO `ttl` mechanism that destroys
sessions after specified `cookie_lifetime` unless renewal occurs during normal
browser activity. Log out the application via XHR request
(or something similar) to manually handle the redirects.

## Logging Out

It is typical to provide users the ability to log out (i.e., to manually destroy) their
current session. Logging out is possible with either query params or `POST` params in
the request URL. The config's `logout_methods` allows the plugin to limit logging
out based on the HTTP verb. When `logout_query_arg` is set, it checks the
presence of the URL query param specified, and likewise when `logout_post_arg`
is set, it checks the presence of the specified variable in the request body.
Allowed HTTP verbs are `GET`, `DELETE`, and `POST`. When there is a session
present and the incoming request is a logout request, the Kong Session plugin
returns a 200 before continuing in the plugin run loop, and the request does not
continue to the upstream.

## Known Limitations

Due to limitations of OpenResty, the `header_filter` phase cannot connect to the
database, which poses a problem for initial retrieval of a cookie (fresh session).
There is a small window of time where the cookie is sent to client, but the database
insert has not been committed yet because the database call is in a `ngx.timer` thread.
The current workaround is to wait for some interval of time (~100-500ms) after
`Set-Cookie` header is sent to the client before making subsequent requests. This is
_not_ a problem during session renewal period as renew happens in `access` phase.

[plugin]: https://docs.konghq.com/hub/
[lua-resty-session]: https://github.com/bungle/lua-resty-session
[multiple authentication]: https://docs.konghq.com/0.14.x/auth/#multiple-authentication
[key auth]: https://docs.konghq.com/hub/kong-inc/key-auth/
[request termination]: https://docs.konghq.com/hub/kong-inc/request-termination/
