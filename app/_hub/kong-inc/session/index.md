---
name: Session
publisher: Kong Inc.
version: 1.0.1-x

desc: Support sessions for Kong authentication plugins.
description: |
  Kong Session plugin can be used to manage browser sessions for APIs proxied 
  through the Kong API Gateway. It provides configuration and management for
  session data storage, encyption, renewal, expiry, and sending browser cookies
  🍪. It is built using
  <a href="https://github.com/bungle/lua-resty-session">lua-resty-session</a>

type: plugin
categories:
  - authentication

source_url: https://github.com/Kong/kong-plugin-session

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.0.x
      - 0.15.x

  enterprise_edition:
    compatible:
      - 0.35-x

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
      description: The duration (in seconds) of a session remaining at which point the plugin renews the session
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
      description: "The methods that may be used to end sessions: POST, DELETE, GET. Do not change this property; doing so will break the ability to use Kong Manager."
    - name: logout_query_arg
      required: false 
      default: session_logout
      description: The query argument passed to logout requests. Do not change this property; doing so will break the ability to use Kong Manager.
    - name: logout_post_arg
      required: false 
      default: session_logout
      description: The post argument passed to logout requests. Do not change this property; doing so will break the ability to use Kong Manager.

---

## Usage

Kong Session plugin can be configured globally or per entity (service, route, etc)
and is always used in conjunction with another Kong authentication [plugin]. This
plugin is intended to work similarly to the [multiple authentication] setup.

Once Kong Session plugin is enabled in conjunction with an authentication plugin,
it will run prior to credential verification. If no session is found, then the
authentication plugin will run and credentials will be checked as normal. If the
credential verification is successful, then the session plugin will create a new
session for usage with subsequent requests. When a new request comes in, and a
session is present, then Kong Session plugin will attach the ngx.ctx variables
to let the authentication plugin know that authentication has already occured via
session validation. Since this configuration is a logical OR scenario, it is desired
that anonymous access be forbidden, then the [request termination] plugin should
be configured on an anonymous consumer. Failure to do so will allow unauthorized
requests. For more information please see section on [multiple authentication].

For usage with [key-auth] plugin

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

1. Configure the key-auth Plugin for the Service

    Issue the following cURL request to add the key-auth plugin to the Service:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/example-service/plugins/ \
      --data 'name=key-auth'
    ```

    Be sure to note the created Plugin `id` - it will be needed later.

1. Verify that the key-auth plugin is properly configured

    Issue the following cURL request to verify that the [key-auth][key-auth]
    plugin was properly configured on the Service:

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

    You'll now re-configure the key-auth plugin to permit anonymous access by 
    issuing the following request (**replace the uuids below by the `id` value
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
    false for the sake of this demo in order to avoid using HTTPS.

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

    Anonymous requests now will return status `403`.

    ```bash
      $ curl -i -X GET \
        --url http://localhost:8000/sessions-test
    ```

    Should return `403`.

1. Verify that the session plugin is properly configured

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
  plugin.

### Defaults

By default, Kong Session plugin favors security using a `Secure`, `HTTPOnly`, 
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

## 🦍 Kong Storage Adapter

Kong Session plugin extends the functionality of [lua-resty-session] with its own
session data storage adapter when `storage=kong`. This will store encrypted
session data into the current database strategy (e.g. postgres, cassandra etc.)
and the cookie will not contain any session data. Data stored in the database is
encrypted and the cookie will contain only the session id, expiration time and 
HMAC signature. Sessions will use built-in Kong DAO ttl mechanism which destroys 
sessions after specified `cookie_lifetime` unless renewal occurs during normal 
browser activity. It is recommended that the application logout via XHR request 
or similar to manually handle redirects.

## 👋🏻 Logging Out

It is typical to provide users the ability to log out, or manually destroy, their
current session. Logging out is done via either query params or POST params in 
the request url. The configs `logout_methods` allows the plugin to limit logging
out based on HTTP verb. When `logout_query_arg` is set, it will check the 
presence of the url query param specified, and likewise when `logout_post_arg`
is set it will check the presence of the specified variable in the request body.
Allowed HTTP verbs are `GET`, `DELETE`, and `POST`. When there is a session 
present and the incoming request is a logout request, Kong Session plugin will 
return a 200 before continuing in the plugin run loop, and the request will not
continue to the upstream.

## Known Limitations

Due to limitations of OpenResty, the `header_filter` phase cannot connect to the
database, which poses a problem for initial retrieval of cookie (fresh session). 
There is a small window of time where cookie is sent to client, but database 
insert has not yet been committed, as database call is in `ngx.timer` thread. 
Current workaround is to wait some interval of time (~100-500ms) after 
`Set-Cookie` header is sent to client before making subsequent requests. This is
_not_ a problem during session renewal period as renew happens in `access` phase.

[plugin]: https://docs.konghq.com/hub/
[lua-resty-session]: https://github.com/bungle/lua-resty-session
[multiple authentication]: https://docs.konghq.com/0.14.x/auth/#multiple-authentication
[key-auth]: https://docs.konghq.com/hub/kong-inc/key-auth/
[request termination]: https://docs.konghq.com/hub/kong-inc/request-termination/
