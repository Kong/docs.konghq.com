---
nav_title: Overview
---

The Kong Session plugin can be used to manage browser sessions for APIs proxied
through the {{site.base_gateway}}. It provides configuration and management for
session data storage, encryption, renewal, expiry, and sending browser cookies.
It is built using
[lua-resty-session](https://github.com/bungle/lua-resty-session).

{% if_version lte:3.4.x %}
For information about configuring and using the Session plugin with the Dev
Portal, see [Sessions in the Dev Portal](/gateway/latest/developer-portal/configuration/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-the-dev-portal).

{% endif_version %}
## How it works

The Session plugin can be configured globally or with an entity (for example, a service or a route)
and is always used in conjunction with another [Kong authentication plugin](/hub/#authentication). This
plugin is intended to work similarly to the [multiple authentication setup](/gateway/latest/configure/auth/#multiple-authentication).

When the Session plugin is enabled in conjunction with an authentication plugin,
it runs before credential verification. If no session is found, then the
authentication plugin runs again and credentials are checked normally. If the
credential verification is successful, then the Session plugin creates a new
session for usage with subsequent requests.

When a new request comes in and a session is already present, then the Session
plugin attaches the `ngx.ctx` variables to let the authentication
plugin know that authentication has already occurred via session validation.
As this configuration is a logical OR scenario, and it's desired that anonymous
access be forbidden, you should configure the [Request Termination](/hub/kong-inc/request-termination/) plugin on an anonymous consumer. 
Failure to do so allows unauthorized requests. 
For more information, see [multiple authentication](/gateway/latest/configure/auth/#multiple-authentication).

### Set up with a database

The following example uses the Session plugin together with the [Key Auth](/hub/kong-inc/key-auth) plugin.

1. Create an example service and a route:

   Issue the following cURL request to create `example-service` pointing to
   httpbin.konghq.com, which echoes the request:

   ```bash
   curl -i -X POST \
     --url http://localhost:8001/services/ \
     --data 'name=example-service' \
     --data 'url=https://httpbin.konghq.com/anything'
   ```

   Add a route to the service:

   ```bash
   curl -i -X POST \
     --url http://localhost:8001/services/example-service/routes \
     --data 'paths[]=/sessions-test'
   ```

   The URL `http://localhost:8000/sessions-test` now echoes whatever is being
   requested.

1. Configure the `key-auth` plugin for the service.

   Issue the following cURL request to add the `key-auth` plugin to the service:

   ```bash
   curl -i -X POST \
     --url http://localhost:8001/services/example-service/plugins/ \
     --data 'name=key-auth'
   ```

   Be sure to note the created plugin `id`, which is needed later.

1. Verify that the `key-auth` plugin is properly configured.

   Issue the following cURL request to verify that the `key-auth`
   plugin is properly configured on the service:

   ```bash
   curl -i -X GET \
     --url http://localhost:8000/sessions-test
   ```

   Since the required header or parameter `apikey` is not specified, and
   anonymous access is not yet enabled, the response should be `401 Unauthorized`.

1. Create a consumer and an anonymous consumer.

   Every request proxied and authenticated by {{site.base_gateway}} must be associated with a
   consumer. You can now create a consumer named `anonymous_users` by issuing
   the following request:

   ```bash
   curl -i -X POST \
     --url http://localhost:8001/consumers/ \
     --data "username=anonymous_users"
   ```

   Be sure to note the consumer `id`, which is needed later.

   Now create a consumer that authenticates via sessions:

   ```bash
   curl -i -X POST \
     --url http://localhost:8001/consumers/ \
     --data "username=fiona"
   ```

1. Provision `key-auth` credentials for your consumer:

   ```bash
   curl -i -X POST \
     --url http://localhost:8001/consumers/fiona/key-auth/ \
     --data 'key=open_sesame'
   ```

1. Enable anonymous access.

   You can now re-configure the `key-auth` plugin to permit anonymous access by
   issuing the following request. Replace the UUIDs in the following example
   with the `id` value from previous steps:

   ```bash
   curl -i -X PATCH \
     --url http://localhost:8001/plugins/<your-key-auth-plugin-id> \
     --data "config.anonymous=<anonymous_consumer_id>"
   ```

1. Add the Session plugin to the service:

   ```bash
   curl -X POST http://localhost:8001/services/example-service/plugins \
     --data "name=session"  \
     --data "config.storage=kong" \
     --data "config.cookie_secure=false"
   ```

   {:.note}
   > **Note:** `cookie_secure` is true by default, and should always be true, but is set to
   > false for the sake of this demo to avoid using HTTPS.

1. Add the Request Termination plugin.

   To disable anonymous access to only allow users access via sessions or via
   authentication credentials, enable the Request Termination plugin:

   ```bash
   curl -X POST http://localhost:8001/services/example-service/plugins \
     --data "name=request-termination"  \
     --data "config.status_code=403" \
     --data "config.message=So long and thanks for all the fish!" \
     --data "consumer.id=<anonymous_consumer_id>"
   ```

### Set up without a database

Add the following snippet to your declarative config file:

```yaml
services:
  - name: example-service
    url: https://httpbin.konghq.com/anything

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

1. Check that anonymous requests are disabled:

   ```bash
   curl -i -X GET \
     --url http://localhost:8000/sessions-test
   ```

   Should return `403`.

2. Verify that a user can authenticate via sessions:

   ```bash
   curl -i -X GET \
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
   curl -i -X GET \
     --url http://localhost:8000/sessions-test \
     -H "cookie:session=emjbJ3MdyDsoDUkqmemFqw..|1544654411|4QMKAE3I-jFSgmvjWApDRmZHMB8."
   ```

   This request should succeed and the `Set-Cookie` response header does not appear
   until the renewal period.

3. Navigate to `http://localhost:8000/sessions-test`.

   If the cookie is attached to the browser session, it should return the
   code `403` and the message “So long and thanks for all the fish!”.

4. Navigate to `http://localhost:8000/sessions-test?apikey=open_sesame`.

   It should return `200` and be authenticated via the `key-auth` key query parameter.

5. Navigate to `http://localhost:8000/sessions-test`.

   It can now use the session cookie that is granted by the Session plugin.

### Defaults

By default, the Kong Session plugin favors security using a `Secure`, `HTTPOnly`,
`Samesite=Strict` cookie. `cookie_domain` is automatically set using Nginx
variable host, but can be overridden.

### Session data storage

The session data can be stored in the cookie itself (encrypted) by setting `storage` to `cookie`,
or [inside Kong by setting `storage` to `kong`](#kong-storage-adapter). The session data stores these context
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

## Kong storage adapter

The Session plugin extends the functionality of [lua-resty-session](https://github.com/bungle/lua-resty-session)
with its own session data storage adapter when `storage=kong`. This stores encrypted
session data into the current database strategy and the cookie does not contain
any session data. Data stored in the database is encrypted and the cookie contains only
the session id, expiration time, and HMAC signature. Sessions use the built-in Kong
DAO `ttl` mechanism that destroys sessions after specified `rolling_timeout` unless renewal
occurs during normal browser activity. Log out the application via XHR request
(or something similar) to manually handle the redirects.

## Logging out

It is typical to provide users the ability to log out (i.e., to manually destroy) their
current session. Logging out is possible with either query parameters or `POST` parameters in
the request URL. The config's `logout_methods` allows the plugin to limit logging
out based on the HTTP verb. When `logout_query_arg` is set, it checks the
presence of the URL query parameter specified, and likewise when `logout_post_arg`
is set, it checks the presence of the specified variable in the request body.
Allowed HTTP verbs are `GET`, `DELETE`, and `POST`. When there is a session
present and the incoming request is a logout request, the Kong Session plugin
returns a 200 before continuing in the plugin run loop, and the request does not
continue to the upstream.

## Known limitations

Due to limitations of OpenResty, the `header_filter` phase cannot connect to the
database, which poses a problem for initial retrieval of a cookie (fresh session).
There is a small window of time where the cookie is sent to client, but the database
insert has not been committed yet because the database call is in a `ngx.timer` thread.
The current workaround is to wait for some interval of time (~100-500ms) after
`Set-Cookie` header is sent to the client before making subsequent requests. This is
_not_ a problem during session renewal period as renew happens in `access` phase.
