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
---

## Kong Configuration

### Create an anonymous consumer

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

### Create a service

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

### Create a route

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

### Set up Microsoft AzureAD

1. Create a SAML Enterprise Application. Refer to the [Microsoft AzureAD documentation](https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/add-application-portal) for more information.
2. Note the identifier (entity ID) and sign on URL parameters.
3. Configure the reply URL (Assertion Consumer Service URL), for example, `https://kong-proxy:8443/saml/consume`.
4. Assign users to the SAML enterprise application.

### Create a plugin on a service

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

## Troubleshooting

### Certificate is valid, but isn't being accepted

**Problem:**
You have a valid certificate specified in the `idp_certificate` field, but you get the following error:

```
[saml] user is unauthorized with error: public key in saml response does not match
```

**Solution:**
If you provide a certificate through the `idp_certificate` field, the certificate must have the header and footer removed.

For example, a standard certificate might look like this, with a header and footer:

```
-----BEGIN CERTIFICATE-----
<certificate contents>
-----END CERTIFICATE-----
```

Remove the header and footer before including the certificate in the `idp_certificate` field:
```
<certificate contents>
```

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

