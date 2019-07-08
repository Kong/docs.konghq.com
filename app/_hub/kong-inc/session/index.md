---
name: Session
publisher: Kong Inc.
version: 2.0.0-x

desc: Support sessions for Kong Authentication Plugins.
description: |
  The Kong Session Plugin can be used to manage browser sessions for APIs proxied 
  through the Kong API Gateway. It provides configuration and management for
  session data storage, encryption, renewal, expiry, and sending browser cookies.
  It is built using
  <a href="https://github.com/bungle/lua-resty-session">lua-resty-session</a>

type: plugin
categories:
  - authentication

source_url: https://github.com/Kong/kong-plugin-session

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.2.x

params:
  name: session
  service_id: true
  route_id: true
  consumer_id: false
  config:
    - name: secret
      required: false
      default: random number generated from `kong.utils.random_string`
      value_in_examples: opensesame
      description:
        The secret that is used in keyed HMAC generation.​
    - name: cookie_name
      required: false
      default: '`session`'
      description: The name of the cookie
    - name: cookie_lifetime
      required: false
      default: 3600
      description: The duration (in seconds) that the session will remain open
    - name: cookie_renew
      required: false
      default: 600
      description: The duration (in seconds) of a session remaining at which point the Plugin renews the session
    - name: cookie_path
      required: false
      default: "/"
      description: The resource in the host where the cookie is available
    - name: cookie_domain
      required: false
      default: Set using Nginx variable host, but may be overridden
      description: The domain with which the cookie is intended to be exchanged
    - name: cookie_samesite
      required: false 
      default: "Strict"
      description: 'Determines whether and how a cookie may be sent with cross-site requests. "Strict": the browser will send cookies only if the request originated from the website that set the cookie. "Lax": same-site cookies are withheld on cross-domain subrequests, but will be sent when a user navigates to the URL from an external site, for example, by following a link. "off": disables the same-site attribute so that a cookie may be sent with cross-site requests. https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies'
    - name: cookie_httponly
      required: false
      default: true
      description: Applies the `HttpOnly` tag so that the cookie is sent only to a server https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies
    - name: cookie_secure
      required: false 
      default: true
      description: Applies the Secure directive so that the cookie may be sent to the server only with an encrypted request over the HTTPS protocol https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies
    - name: cookie_discard
      required: false
      default: 10
      description: The duration (in seconds) after which an old session’s TTL is updated that an old cookie is discarded.
    - name: storage
      required: false 
      default: "cookie"
      description: "Determines where the session data is stored. `kong`: stores encrypted session data into Kong's current database strategy (e.g. Postgres, Cassandra); the cookie will not contain any session data. `cookie`: stores encrypted session data within the cookie itself."
    - name: logout_methods
      required: false 
      default: '[`"POST"`, `"DELETE"`]'
      description: 'The methods that may be used to end sessions: POST, DELETE, GET.'
    - name: logout_query_arg
      required: false 
      default: session_logout
      description: The query argument passed to logout requests.
    - name: logout_post_arg
      required: false 
      default: session_logout
      description: The post argument passed to logout requests. Do not change this property.

---

## Usage

The Kong Session **Plugin** can be configured globally or per entity (e.g., Service, Route)
and is always used in conjunction with another Kong Authentication **[Plugin]**. This
**Plugin** is intended to work similarly to the [multiple authentication] setup.

Once the Kong Session **Plugin** is enabled in conjunction with an Authentication **Plugin**,
it will run prior to credential verification. If no session is found, then the
authentication **Plugin** will run and credentials will be checked as normal. If the
credential verification is successful, then the session **Plugin** will create a new
session for usage with subsequent requests. 

When a new request comes in, and a session is present, then the Kong Session 
**Plugin** will attach the `ngx.ctx` variables to let the authentication 
**Plugin** know that authentication has already occured via session validation. 
Since this configuration is a logical OR scenario, it is desired that anonymous 
access be forbidden, then the [Request Termination] **Plugin** should be 
configured on an anonymous consumer. Failure to do so will allow unauthorized
requests. For more information please see section on [multiple authentication].

### Setup With a Database

For usage with [Key Auth] **Plugin**

1. Create an example Service and a Route

    Issue the following cURL request to create `example-service` pointing to 
    mockbin.org, which will echo the request:

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

    The url `http://localhost:8000/sessions-test` will now echo whatever is being 
    requested.

1. Configure the key-auth **Plugin** for the Service

    Issue the following cURL request to add the key-auth **Plugin** to the Service:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/example-service/plugins/ \
      --data 'name=key-auth'
    ```

    Be sure to note the created **Plugin** `id` - it will be needed later.

1. Verify that the key-auth **Plugin** is properly configured

    Issue the following cURL request to verify that the [key-auth][key-auth]
    **Plugin** was properly configured on the Service:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/sessions-test
    ```

    Since the required header or parameter `apikey` was not specified, and 
    anonymous access was not yet enabled, the response should be `401 Unauthorized`:

1. Create a Consumer and an anonymous Consumer

    Every request proxied and authenticated by Kong must be associated with a 
    Consumer. You'll now create a Consumer named `anonymous_users` by issuing 
    the following request:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/consumers/ \
      --data "username=anonymous_users"
    ```

    Be sure to note the Consumer `id` - you'll need it in a later step.

    Now create a consumer that will authenticate via sessions
    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/consumers/ \
      --data "username=fiona"
    ```

1. Provision key-auth credentials for your Consumer
    
    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/consumers/fiona/key-auth/ \
      --data 'key=open_sesame'
    ```

1. Enable anonymous access

    You'll now re-configure the key-auth **Plugin** to permit anonymous access by 
    issuing the following request (**replace the uuids below by the `id` value
    from previous steps**):

    ```bash
    $ curl -i -X PATCH \
      --url http://localhost:8001/plugins/<your-key-auth-plugin-id> \
      --data "config.anonymous=<anonymous_consumer_id>"
    ```

1. Add the Kong Session **Plugin** to the service

    ```bash
    $ curl -X POST http://localhost:8001/services/example-service/plugins \
        --data "name=session"  \
        --data "config.storage=kong" \
        --data "config.cookie_secure=false"
    ```
    > Note: cookie_secure is true by default, and should always be true, but is set to
    false for the sake of this demo in order to avoid using HTTPS.

1. Add the Request Termination **Plugin**

    To disable anonymous access to only allow users access via sessions or via
    authentication credentials, enable the Request Termination **Plugin**.

    ```bash
    $ curl -X POST http://localhost:8001/services/example-service/plugins \
        --data "name=request-termination"  \
        --data "config.status_code=403" \
        --data "config.message=So long and thanks for all the fish!" \
        --data "consumer.id=<anonymous_consumer_id>"
    ```

### Setup Without a Database

Add all these to the declarative config file:

``` yaml
services:
- name: example-service
  url: http://mockbin.org/request

routes:
- service: example-service
  paths: [ "/sessions-test" ]

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
    message: "So long and thanks for all the fish!"
```

### Verification

1. Check that Anonymous requests are disabled

   ``` bash
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

    This request should succeed, and `Set-Cookie` response header will not appear
    until renewal period.

1. You can also now verify cookie is attached to browser session: Navigate to 
  http://localhost:8000/sessions-test  which should return `403` 
  and see the message "So long and thanks for all the fish!"
1. In same browser session, navigate to http://localhost:8000/sessions-test?apikey=open_sesame 
  which should return `200`, authenticated via key-auth key query param.
1. In same browser session, navigate to http://localhost:8000/sessions-test, 
  which will now use the session cookie that was granted by the Kong Session 
  **Plugin**.

### Defaults

By default, the Kong Session **Plugin** favors security using a `Secure`, `HTTPOnly`, 
`Samesite=Strict` cookie. `cookie_domain` is automatically set using Nginx 
variable host, but can be overridden.

### Session Data Storage

The session data can be stored in the cookie itself (encrypted) `storage=cookie`, 
or inside [Kong](#-kong-storage-adapter). The session data stores two context
variables:

```
ngx.ctx.authenticated_consumer.id
ngx.ctx.authenticated_credential.id
```

## Kong Storage Adapter

the Kong Session **Plugin** extends the functionality of [lua-resty-session] with its own
session data storage adapter when `storage=kong`. This will store encrypted
session data into the current database strategy (e.g. postgres, cassandra etc.)
and the cookie will not contain any session data. Data stored in the database is
encrypted and the cookie will contain only the session id, expiration time and 
HMAC signature. Sessions will use the built-in Kong DAO `ttl` mechanism which destroys 
sessions after specified `cookie_lifetime` unless renewal occurs during normal 
browser activity. It is recommended that the application logout via XHR request 
(or something similar) to manually handle redirects.

## Logging Out

It is typical to provide users the ability to log out (i.e. to manually destroy) their
current session. Logging out is possible with either query params or `POST` params in 
the request URL. The config's `logout_methods` allows the **Plugin** to limit logging
out based on the HTTP verb. When `logout_query_arg` is set, it will check the 
presence of the URL query param specified, and likewise when `logout_post_arg`
is set it will check the presence of the specified variable in the request body.
Allowed HTTP verbs are `GET`, `DELETE`, and `POST`. When there is a session 
present and the incoming request is a logout request, the Kong Session **Plugin** will 
return a 200 before continuing in the **Plugin** run loop, and the request will not
continue to the upstream.

## Known Limitations

Due to limitations of OpenResty, the `header_filter` phase cannot connect to the
database, which poses a problem for initial retrieval of cookie (fresh session). 
There is a small window of time where cookie is sent to client, but database 
insert has not yet been committed, as database call is in `ngx.timer` thread. 
Current workaround is to wait some interval of time (~100-500ms) after 
`Set-Cookie` header is sent to client before making subsequent requests. This is
_not_ a problem during session renewal period as renew happens in `access` phase.

[Plugin]: https://docs.konghq.com/hub/
[lua-resty-session]: https://github.com/bungle/lua-resty-session
[multiple authentication]: https://docs.konghq.com/0.14.x/auth/#multiple-authentication
[Key Auth]: https://docs.konghq.com/hub/kong-inc/key-auth/
[Request Termination]: https://docs.konghq.com/hub/kong-inc/request-termination/
