---
name: SAML
publisher: Kong Inc.
desc: Provides SAML v2.0 authentication and authorization between a Service Provider (Kong) and an Identity Provider
description: |

  Security Assertion Markup Language (SAML) is an open standard for
  exchanging authentication and authorization data between an identity
  provider and a service provider.

  The SAML specification defines three roles:

  * A principal
  * An identity provider (IdP)
  * A service provider (SP)

  The Kong SAML plugin acts as the SP and is responsible for
  initiating a login to the IdP. This is called an SP Initiated Login.

  The minimum configuration required is:

  - An IdP certificate `idp_certificate`.  The SP needs to obtain the
    public certificate from the IdP to validate the signature. The
    certificate is stored on the SP and is to verify that a response
    is coming from the IdP.
  - ACS Endpoint `assertion_consumer_path`. This is the endpoint
    provided by the SP where SAML responses are posted. The SP needs
    to provide this information to the IdP.
  - IdP Sign-in URL `idp_sso_url`.  This is the IdP endpoint where
    SAML will issue `POST` requests. The SP needs to obtain this
    information from the IdP.
  - Issuer `issuer`.   Unique identifier of the IdP application.

  The plugin currently supports SAML 2.0 with Microsoft Azure Active
  Directory.  Please refer to the
  [Microsoft AzureAD SAML documentation](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/auth-saml)
  for more information about SAML authentication with Azure AD.
  
  As the SP initiated mode of SAML requires the client to authenticate
  to the IdP using a web browser, the plugin is only useful when it is
  used with a browser-based web application.
  
  It is designed to intercept requests sent from the client to the
  upstream to detect whether a session has been established by
  authenticating with the IdP.  If no session is found, the request is
  redirected to the IdP's login page for authentication.  Once the
  user has successfully authenticated, the user is redirected to the
  application and the original request is sent to the upstream
  server.
  
  The authentication process can only be initiated when the request is
  coming from a web browser.  The plugin determines this by matching
  the request's `Accept` header.  If it contains the string
  "text/html", the request is redirected to the IdP, otherwise it is
  responded to with a 401 (Unauthorized) status code.
  
  The plugin initiates the redirection to the IdP's login page by
  responding with an HTML form that contains the authentication
  request details in hidden parameters and some JavaScript code to
  automatically submit the form.  This is needed because the
  authentication parameters need to be transmitted to Azure's SAML
  implementation using a POST request, which cannot be done with a
  HTTP redirect response.
  
  The plugin supports initiating the IdP authentication flow from a
  POST request, to support the use case that the session expires while
  the user is filling out a web form.  In such scenarios, the plugin
  transmits the posted form parameters to the IdP in the `RelayState`
  parameter in encrypted form.  When the authentication process
  finishes, the IdP sends the `RelayState` back to the plugin.  After
  decryption, the plugin then responds back to the web browser with
  another automatically self-submitting form containing the original
  form parameters as hidden parameters.  This feature is only
  available with forms that use "application/x-www-form-urlencoded" as
  their content type.  Forms that use "text/plain" or
  "multipart/form-data" are not supported.

  When the authentication process has finished, the plugin creates and
  maintains a session inside of Kong gateway.  A cookie in the browser
  is used to track the session.  Data that is attached to the session
  can be stored in redis, memcached or in the cookie itself.  Note
  that the lifetime of the session that is created by the IdP is needs
  to be configured in the plugin itself.

enterprise: true
plus: true
type: plugin
categories:
  - security
kong_version_compatibility:
  enterprise_edition:
    compatible: true
params:
  name: saml
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
  dbless_compatible: 'yes'
  config:
    - name: anonymous
      required: false
      default: null
      value_in_examples: anonymous
      datatype: string
      description:
        An optional string (consumer UUID or username) value to use as an “anonymous” consumer. If not set, a Kong Consumer must exist for the SAML IdP user credentials, mapping the username format to the Kong Consumer username.
    - name: assertion_consumer_path
      required: true
      datatype: url
      default: null
      value_in_examples: <acs-uri>
      description: |
        The relative path the SAML IdP provider uses when responding with an authentication response.
    - name: idp_sso_url
      required: true
      datatype: url
      default: null
      value_in_examples: <sso-uri>
      description: |
        The Single Sign-On URL exposed by the IdP provider. This is where SAML requests are posted. The IdP provides this information.
    - name: idp_certificate
      required: true
      datatype: string
      default: null
      referenceable: true
      description: |
        The public certificate provided by the IdP. This is used to validate responses from the IdP.
    - name: encryption_key
      required: false
      datatype: string
      default: null
      referenceable: true
      description: |
        The private encryption key required to decrypt encrypted assertions.
    - name: request_signing_key
      required: false
      datatype: string
      default: null
      referenceable: true
      description: |
        The private key for signing requests.  If this parameter is
        set, requests sent to the IdP are signed.  The
        `request_signing_certificate` parameter must be set as well.
    - name: request_signing_certificate
      required: false
      datatype: string
      default: null
      referenceable: true
      description: |
        The certificate for signing requests.
    - name: request_signature_algorithm
      required: false
      datatype: string
      default: SHA256
      description: |
        The signature algorithm for signing Authn requests. Options available are:
        - `SHA256`
        - `SHA384`
        - `SHA512`
    - name: request_digest_algorithm
      required: false
      datatype: string
      default: SHA256
      description: |
        The digest algorithm for Authn requests:
        - `SHA256`
        - `SHA1`
    - name: response_signature_algorithm
      required: false
      datatype: string
      default: SHA256
      description: |
        The algorithm for validating signatures in SAML responses. Options available are:
        - `SHA256`
        - `SHA384`
        - `SHA512`
    - name: response_digest_algorithm
      required: false
      datatype: string
      default: SHA256
      description: |
        The algorithm for verifying digest in SAML responses:
        - `SHA256`
        - `SHA1`
    - name: issuer
      required: true
      datatype: string
      default: null
      description: |
        The unique identifier of the IdP application. Formatted as a URL containing information about the IdP so the SP can validate that the SAML assertions it receives are issued from the correct IdP.
    - name: nameid_format
      required: false
      datatype: string
      default: EmailAddress
      description: |
        The requested `NameId` format. Options available are:
        - `Unspecified`
        - `EmailAddress`
        - `Persistent`
        - `Transient`
    - name: validate_assertion_signature
      required: false
      datatype: boolean
      default: true
      value_in_examples: true
      description: |
        Enable signature validation for SAML responses.
    - group: Session cookie
      description: Parameters used with session cookie authentication.
    - name: session_cookie_name
      required: false
      default: session
      datatype: string
      description: The session cookie name.
    - name: session_cookie_lifetime
      maximum_version: "3.1.x"
      required: false
      default: 3600
      datatype: integer
      description: The session cookie lifetime in seconds.
    - name: session_rolling_timeout
      minimum_version: "3.2.x"
      required: false
      default: 3600
      datatype: integer
      description: |
        The session cookie rolling timeout in seconds.
        Specifies how long the session can be used until it needs to be renewed.
    - name: session_absolute_timeout
      minimum_version: "3.2.x"
      required: false
      default: 86400
      datatype: integer
      description: |
        The session cookie absolute timeout in seconds.
        Specifies how long the session can be used until it is no longer valid.
    - name: session_cookie_idletime
      maximum_version: "3.1.x"
      required: false
      default: null
      datatype: integer
      description: The session cookie idle time in seconds.
    - name: session_idling_timeout
      minimum_version: "3.2.x"
      required: false
      default: 900
      datatype: integer
      description: The session cookie idle time in seconds.
    - name: session_cookie_renew
      maximum_version: "3.1.x"
      required: false
      default: 600
      datatype: integer
      description: The session cookie renew time in seconds.
    - name: session_cookie_path
      required: false
      default: /
      datatype: string
      description: The session cookie path flag.
    - name: session_cookie_domain
      required: false
      default: null
      datatype: string
      description: The session cookie domain flag.
    - name: session_cookie_samesite
      maximum_version: "3.1.x"
      required: false
      default: Lax
      datatype: string
      description: |
        Controls whether a cookie is sent with cross-origin requests, providing some protection against cross-site request forgery attacks:
        - `Strict`: Cookies will only be sent in a first-party context and not be sent along with requests initiated by third party websites.
        - `Lax`: Cookies are not sent on normal cross-site subrequests, like loading images or frames into a third party site, but are sent when a user is navigating to the origin site, like when they are following a link.
        - `None`: Cookies will be sent in all contexts, including responses to both first-party and cross-origin requests. If `SameSite=None` is set, the cookie secure attribute must also be set or the cookie will be blocked.
        - `off`: Do not set the Same-Site flag.
    - name: session_cookie_same_site
      minimum_version: "3.2.x"
      required: false
      default: Lax
      datatype: string
      description: |
        Controls whether a cookie is sent with cross-origin requests, providing some protection against cross-site request forgery attacks:
        - `Strict`: Cookies will only be sent in a first-party context and aren't sent along with requests initiated by third party websites.
        - `Lax`: Cookies are not sent on normal cross-site subrequests, like loading images or frames into a third party site, but are sent when a user is navigating to the origin site, like when they are following a link.
        - `None`: Cookies will be sent in all contexts, including responses to both first party and cross-origin requests. If `SameSite=None` is set, the cookie secure attribute must also be set or the cookie will be blocked.
        - `Default`: Do not explicitly specify a Same-Site attribute.
    - name: session_cookie_httponly
      maximum_version: "3.1.x"
      required: false
      default: true
      datatype: boolean
      description: Forbids JavaScript from accessing the cookie, for example, through the `Document.cookie` property.
    - name: session_cookie_http_only
      minimum_version: "3.2.x"
      required: false
      default: true
      datatype: boolean
      description: Forbids JavaScript from accessing the cookie, for example, through the `Document.cookie` property.
    - name: session_cookie_secure
      required: false
      default: (from the request scheme)
      datatype: boolean
      description: |
        The cookie is only sent to the server when a request is made with the https:scheme (except on localhost),
        and therefore is more resistant to man-in-the-middle attacks.
    - name: session_cookie_maxsize
      maximum_version: "3.1.x"
      required: false
      default: 4000
      datatype: integer
      description: The maximum size of each cookie in bytes.
    - group: Session Settings
    - name: session_secret
      required: true
      datatype: string
      encrypted: true
      referenceable: true
      description: |
        The session secret. This must be a random string of 32
        characters from the base64 alphabet (letters, numbers, `/`, `_`
        and `+`). It is used as the secret key for encrypting session
        data as well as state information that is sent to the IdP in
        the authentication exchange.
    - name: session_strategy
      maximum_version: "3.1.x"
      required: false
      default: default
      datatype: string
      description: |
        The session strategy:
        - `default`:  reuses session identifiers over modifications (but can be problematic with single-page applications with a lot of concurrent asynchronous requests)
        - `regenerate`: generates a new session identifier on each modification and does not use expiry for signature verification. This is useful in single-page applications or SPAs.
    - name: session_compressor
      maximum_version: "3.1.x"
      required: false
      default: none
      datatype: string
      description: |
        The session strategy:
        - `none`: no compression.
        - `zlib`: use Zlib to compress cookie data.
    - name: session_audience
      minimum_version: "3.2.x"
      required: false
      default: '"default"'
      datatype: string
      description: The session audience, for example "my-application"
    - name: session_remember
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: Enables or disables persistent sessions
    - name: session_remember_cookie_name
      minimum_version: "3.2.x"
      required: false
      default: '"remember"'
      datatype: string
      description: Persistent session cookie name
    - name: session_remember_rolling_timeout
      minimum_version: "3.2.x"
      required: false
      default: 604800
      datatype: integer
      description: Persistent session rolling timeout in seconds.
    - name: session_remember_absolute_timeout
      minimum_version: "3.2.x"
      required: false
      default: 2592000
      datatype: integer
      description: Persistent session absolute timeout in seconds.
    - name: session_request_headers
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: array of string elements
      description: |
        List of information to include (as headers) in the request to upstream. 
        Accepted values are: `id`, `audience`, `subject`, `timeout`, `idling-timeout`, `rolling-timeout`, and
        `absolute-timeout`.
        For example, { "id", "timeout" } will set both `Session-Id` and `Session-Timeout` in the request headers.
    - name: session_response_headers
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: array of string elements
      description: |
        List of information to include (as headers) in the response to downstream. 
        Accepted values are: `id`, `audience`, `subject`, `timeout`, `idling-timeout`, `rolling-timeout`, and
        `absolute-timeout`.
        For example: { "id", "timeout" } will inject both `Session-Id` and `Session-Timeout` in the response headers.
    - name: session_store_metadata
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: | 
        Configures whether or not session metadata should be stored.
        This includes information about the active sessions for the `specific_audience`
        belonging to a specific subject.
    - name: session_enforce_same_subject
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: When set to `true`, audiences are forced to share the same subject.
    - name: session_hash_subject
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: |
        When set to `true`, the value of subject is hashed before being stored.
        Only applies when `session_store_metadata` is enabled.
    - name: session_hash_storage_key
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: |
        When set to `true`, the storage key (session ID) is hashed for extra security.
        Hashing the storage key means it is impossible to decrypt data from the storage
        without a cookie.
    - name: session_storage
      required: false
      default: cookie
      datatype: string
      description: |
        The session storage for session data:
        - `cookie`: stores session data with the session cookie. The session cannot be invalidated or revoked without changing the session secret, but is stateless, and doesn't require a database.
        - `memcached`: stores session data in memcached
        - `redis`: stores session data in Redis
    - name: reverify
      required: false
      default: false
      datatype: boolean
      description: Specifies whether to always verify tokens stored in the session.
    - group: Session Settings for Memcached
    - name: session_memcache_prefix
      maximum_version: "3.1.x"
      required: false
      default: sessions
      datatype: string
      description: The memcached session key prefix.
    - name: session_memcached_prefix
      minimum_version: "3.2.x"
      required: false
      default: '"sessions"'
      datatype: string
      description: The memcached session key prefix.
    - name: session_memcache_socket
      maximum_version: "3.1.x"
      required: false
      default: null
      datatype: string
      description: The memcached unix socket path.
    - name: session_memcached_socket
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: string
      description: The memcached unix socket path.
    - name: session_memcache_host
      maximum_version: "3.1.x"
      required: false
      default: 127.0.0.1
      datatype: string
      description: The memcached host.
    - name: session_memcached_host
      minimum_version: "3.2.x"
      required: false
      default: '"127.0.0.1"'
      datatype: string
      description: The memcached host.
    - name: session_memcache_port
      maximum_version: "3.1.x"
      required: false
      default: 11211
      datatype: integer
      description: The memcached port.
    - name: session_memcached_port
      minimum_version: "3.2.x"
      required: false
      default: 11211
      datatype: integer
      description: The memcached port.
    - group: Session Settings for Redis
    - name: session_redis_prefix
      required: false
      default: sessions
      datatype: string
      description: The Redis session key prefix.
    - name: session_redis_socket
      required: false
      default: null
      datatype: string
      description: The Redis unix socket path.
    - name: session_redis_host
      required: false
      default: 127.0.0.1
      datatype: string
      description: The Redis host IP.
    - name: session_redis_port
      required: false
      default: 6379
      datatype: integer
      description: The Redis port.
    - name: session_redis_username
      required: false
      default: null
      datatype: string
      referenceable: true
      description: |
        Redis username if the `redis` session storage is defined and ACL authentication is desired.
        If undefined, ACL authentication will not be performed.

        This requires Redis v6.0.0+. The username **cannot** be set to `default`.
    - name: session_redis_password
      required: false
      default: (from kong)
      encrypted: true
      datatype: string
      referenceable: true
      description: |
        Password to use for Redis connection when the `redis` session storage is defined.
        If undefined, no auth commands are sent to Redis. This value is pulled from
    - name: session_redis_connect_timeout
      required: false
      default: (from kong)
      datatype: integer
      description: The Redis connection timeout in milliseconds.
    - name: session_redis_read_timeout
      required: false
      default: (from kong)
      datatype: integer
      description: The Redis read timeout in milliseconds.
    - name: session_redis_send_timeout
      required: false
      default: (from kong)
      datatype: integer
      description: The Redis send timeout in milliseconds.
    - name: session_redis_ssl
      required: false
      default: false
      datatype: boolean
      description: Use SSL/TLS for the Redis connection.
    - name: session_redis_ssl_verify
      required: false
      default: false
      datatype: boolean
      description: Verify the Redis server certificate.
    - name: session_redis_server_name
      required: false
      default: null
      datatype: string
      description: The SNI used for connecting to the Redis server.
    - name: session_redis_cluster_nodes
      required: false
      default: null
      datatype: array of host records
      description: |
        The Redis cluster node host. Takes an array of host records, with
        either `ip` or `host`, and `port` values.
    - name: session_redis_cluster_maxredirections
      maximum_version: "3.1.x"
      required: false
      default: null
      datatype: integer
      description: The Redis cluster's maximum redirects.
    - name: session_redis_cluster_max_redirections
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: integer
      description: The Redis cluster maximum redirects.
---

## Kong Configuration

### Create an Anonymous Consumer:

```bash
curl --request PUT \
  --url http://localhost:8001/consumers/anonymous
```

```json
{
    "created_at": 1667352450,
    "custom_id": null,
    "id": "bec9d588-073d-4491-b210-1d07099bfcde",
    "tags": null,
    "type": 0,
    "username": "anonymous",
    "username_lower": null
}
```

### Create a Service

```bash
curl --request PUT \
  --url http://localhost:8001/services/saml-service \
  --data url=https://httpbin.org/anything
```

```json
{
    "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd",
    "name": "saml-service",
    "protocol": "https",
    "host": "httpbin.org",
    "port": 443,
    "path": "/anything"
}
```

### Create a Route

```bash
curl --request PUT \
  --url http://localhost:8001/services/saml-service/routes/saml-route \
  --data paths=/saml
```

```json
{
    "id": "ac1e86bd-4bce-4544-9b30-746667aaa74a",
    "name": "saml-route",
    "paths": [ "/saml" ]
}
```

### Setup Microsoft AzureAD

1. Create a SAML Enterprise Application. Refer to the [Microsoft AzureAD documentation](https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/add-application-portal) for more information.
2. Note the identifier (entity ID) and sign on URL parameters
3. Configure the reply URL (Assertion Consumer Service URL), for example, `https://kong-proxy:8443/saml/consume`
4. Assign users to the SAML enterprise application

### Create a Plugin on a Service

Validation of the SAML response assertion is disabled in the plugin configuration below. This configuration should not be used in a production environment.

Replace the `Azure_Identity_ID` value below, with the `identifier` value from the single sign-on - basic SAML configuration from the Manage section of the Microsoft AzureAD enterprise application:

<img src="/assets/images/docs/saml/azuread_basic_config.png">

Replace the `AzureAD_Sign_on_URL` value below, with the `Login URL` value from the single sign-on - Set up Service Provider section from the Manage section of the Microsoft AzureAD enterprise application:

<img src="/assets/images/docs/saml/azuread_sso_url.png">

```bash
curl --request POST \
  --url http://localhost:8001/services/saml-service/plugins \
  --header 'Content-Type: multipart/form-data' \
  --form name=saml \
  --form config.anonymous=anonymous \
  --form service.name=saml-service \
  --form config.issuer=AzureAD_Identity_ID \
  --form config.idp_sso_url=AzureAD_Sign_on_URL \
  --form config.assertion_consumer_path=/consume \
  --form config.validate_assertion_signature=false
```

```json
{
    "id": "a8655ba0-de99-48fc-b52f-d7ed030a755c",
    "name": "saml",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "assertion_consumer_path": "/consume",
        "validate_assertion_signature": true,
        "idp_sso_url": "https://login.microsoftonline.com/f177c1d6-50cf-49e0-818a-a0585cbafd8d/saml2",
        "issuer": "https://samltoolkit.azurewebsites.net/kong_saml"
    }
}
```

### Test the SAML plugin

1. Using a browser, go to the URL (https://kong:8443/saml)
2. The browser is redirected to the AzureAD Sign in page. Enter the user credentials of a user configured in AzureAD
3. If user credentials are valid, the browser will be redirected to https://httpbin.org/anything
4. If the user credentials are invalid, a `401` unauthorized HTTP status code is returned

## Changelog

**{{site.base_gateway}} 3.2.x**
* The plugin has been updated to use version 4.0.0 of the `lua-resty-session` library. This introduced several new features, such as the possibility to specify audiences.
The following configuration parameters were affected:

Added:
  * `session_audience`
  * `session_remember`
  * `session_remember_cookie_name`
  * `session_remember_rolling_timeout`
  * `session_remember_absolute_timeout`
  * `session_absolute_timeout`
  * `session_request_headers`
  * `session_response_headers`
  * `session_store_metadata`
  * `session_enforce_same_subject`
  * `session_hash_subject`
  * `session_hash_storage_key`

Renamed:
  * `session_cookie_lifetime` to `session_rolling_timeout`
  * `session_cookie_idletime` to `session_idling_timeout`
  * `session_cookie_samesite` to `session_cookie_same_site`
  * `session_cookie_httponly` to `session_cookie_http_only`
  * `session_memcache_prefix` to `session_memcached_prefix`
  * `session_memcache_socket` to `session_memcached_socket`
  * `session_memcache_host` to `session_memcached_host`
  * `session_memcache_port` to `session_memcached_port`
  * `session_redis_cluster_maxredirections` to `session_redis_cluster_max_redirections`

Removed:
  * `session_cookie_renew`
  * `session_cookie_maxsize`
  * `session_strategy`
  * `session_compressor`
