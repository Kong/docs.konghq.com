---
nav_title: Overview
issuer_body: |
  Attributes | Description
  ---:| ---
  `name`<br>*optional* | The Service name.
  `retries`<br>*optional* | The number of retries to execute upon failure to proxy. Default: `5`.
  `protocol` |  The protocol used to communicate with the upstream.  Accepted values are: `"grpc"`, `"grpcs"`, `"http"`, `"https"`, `"tcp"`, `"tls"`, `"udp"`.  Default: `"http"`.
  `host` | The host of the upstream server.
  `port` | The upstream server port. Default: `80`.
  `path`<br>*optional* | The path to be used in requests to the upstream server.
  `connect_timeout`<br>*optional* |  The timeout in milliseconds for establishing a connection to the upstream server.  Default: `60000`.
  `write_timeout`<br>*optional* |  The timeout in milliseconds between two successive write operations for transmitting a request to the upstream server.  Default: `60000`.
  `read_timeout`<br>*optional* |  The timeout in milliseconds between two successive read operations for transmitting a request to the upstream server.  Default: `60000`.
  `tags`<br>*optional* |  An optional set of strings associated with the Service for grouping and filtering.
  `client_certificate`<br>*optional* |  Certificate to be used as client certificate while TLS handshaking to the upstream server. With form-encoded, the notation is `client_certificate.id=<client_certificate id>`. With JSON, use "`"client_certificate":{"id":"<client_certificate id>"}`.
  `tls_verify`<br>*optional* |  Whether to enable verification of upstream server TLS certificate. If set to `null`, then the Nginx default is respected.
  `tls_verify_depth`<br>*optional* |  Maximum depth of chain while verifying Upstream server's TLS certificate. If set to `null`, then the Nginx default is respected.  Default: `null`.
  `ca_certificates`<br>*optional* |  Array of `CA Certificate` object UUIDs that are used to build the trust store while verifying upstream server's TLS certificate. If set to `null` when Nginx default is respected. If default CA list in Nginx are not specified and TLS verification is enabled, then handshake with upstream server will always fail (because no CA are trusted).  With form-encoded, the notation is `ca_certificates[]=4e3ad2e4-0bc4-4638-8e34-c84a417ba39b&ca_certificates[]=51e77dc2-8f3e-4afa-9d0e-0e3bbbcfd515`. With JSON, use an Array.
  `url`<br>*shorthand-attribute* |  Shorthand attribute to set `protocol`, `host`, `port` and `path` at once. This attribute is write-only (the Admin API never returns the URL).
issuer_json: |
  {
      "id": "<uuid>",
      "issuer": "<config.issuer>"
      "created_at": <timestamp>,
      "configuration": {
          <discovery>
      },
      "keys": [
          <keys>
      ]
  }
issuer_data: |
  {
      "data": [{
          "id": "<uuid>",
          "issuer": "<config.issuer>"
          "created_at": <timestamp>,
          "configuration": {
              <discovery>
          },
          "keys": [
              <keys>
          ]
      }],
      "next": null
  }
host: |
  {
      "ip": "127.0.0.1"
      "port": 6379
  }
jwk: |
  {
      "kid": "B2FxBJ8G_e61tnZEfaYpaMLjswjNO3dbVEQhR7-i_9s",
      "kty": "RSA",
      "alg": "RS256",
      "use": "sig"
      "e": "AQAB",
      "n": "…",
      "d": "…",
      "p": "…",
      "q": "…",
      "dp": "…",
      "dq": "…",
      "qi": "…"
  }
jwks: |
  {
      "keys": [{
          <keys>
      }]
  }
---

OpenID Connect ([1.0][connect]) plugin allows for integration with a third party
identity provider (IdP) in a standardized way. This plugin can be used to implement
Kong as a (proxying) [OAuth 2.0][oauth2] resource server (RS) and/or as an OpenID
Connect relying party (RP) between the client, and the upstream service.

The plugin supports several types of credentials and grants:

- Signed [JWT][jwt] access tokens ([JWS][jws])
- Opaque access tokens
- Refresh tokens
- Authorization code with client secret or PKCE
- Username and password
- Client credentials
- Session cookies

The plugin has been tested with several OpenID Connect providers:

- [Auth0][auth0] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-auth0/))
- [Amazon AWS Cognito][cognito] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-cognito/))
- [Connect2id][connect2id]
- [Curity][curity]
- [Dex][dex]
- [Gluu][gluu]
- [Google][google] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-google/))
- [IdentityServer][identityserver]
- [Keycloak][keycloak]
- [Microsoft Azure Active Directory][azure] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-azuread/))
- [Microsoft Active Directory Federation Services][adfs]
- [Microsoft Live Connect][liveconnect]
- [Okta][okta] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-okta/))
- [OneLogin][onelogin]
- [OpenAM][openam]
- [PayPal][paypal]
- [PingFederate][pingfederate]
- [Salesforce][salesforce]
- [WSO2][wso2]
- [Yahoo!][yahoo]

As long as your provider supports OpenID Connect standards, the plugin should
work, even if it is not specifically tested against it. Let Kong know if you
want your provider to be tested and added to the list.

[curity]: https://curity.io/resources/learn/openid-connect-overview/
[connect]: http://openid.net/specs/openid-connect-core-1_0.html
[oauth2]: https://tools.ietf.org/html/rfc6749
[jwt]: https://tools.ietf.org/html/rfc7519
[jws]: https://tools.ietf.org/html/rfc7515
[auth0]: https://auth0.com/docs/protocols/openid-connect-protocol
[cognito]: https://aws.amazon.com/cognito/
[connect2id]: https://connect2id.com/products/server
[curity]: https://curity.io/resources/learn/openid-connect-overview/
[dex]: https://dexidp.io/docs/openid-connect/
[gluu]: https://gluu.org/docs/ce/api-guide/openid-connect-api/
[google]: https://developers.google.com/identity/protocols/oauth2/openid-connect
[identityserver]: https://duendesoftware.com/
[keycloak]: http://www.keycloak.org/documentation.html
[azure]: https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc
[adfs]: https://docs.microsoft.com/en-us/windows-server/identity/ad-fs/development/ad-fs-openid-connect-oauth-concepts
[liveconnect]: https://docs.microsoft.com/en-us/advertising/guides/authentication-oauth-live-connect
[okta]: https://developer.okta.com/docs/api/resources/oidc.html
[onelogin]: https://developers.onelogin.com/openid-connect
[openam]: https://backstage.forgerock.com/docs/openam/13.5/admin-guide/#chap-openid-connect
[paypal]: https://developer.paypal.com/docs/log-in-with-paypal/integrate/
[pingfederate]: https://docs.pingidentity.com/r/en-us/pingfederate-112/pf_pingfederate_landing_page
[salesforce]: https://help.salesforce.com/articleView?id=sf.sso_provider_openid_connect.htm&type=5
[wso2]: https://is.docs.wso2.com/en/latest/guides/identity-federation/configure-oauth2-openid-connect/
[yahoo]: https://developer.yahoo.com/oauth2/guide/openid_connect/

Once applied, any user with a valid credential can access the service.

This plugin can be used for authentication in conjunction with the
[Application Registration](/hub/kong-inc/application-registration/) plugin.

## Important Configuration Parameters

This plugin includes many configuration parameters that allow finely grained customization.
The following steps will help you get started setting up the plugin:

1. Configure: `config.issuer`.

    This parameter tells the plugin where to find discovery information, and it is
    the only required parameter. You should set the value `realm` or `iss` on this
    parameter if you don't have a discovery endpoint.

    {:.note}
    > **Note**: This does not have
    to match the URL of the `iss` claim in the access tokens being validated. To set
    URLs supported in the `iss` claim, use `config.issuers_allowed`.

2. Decide what authentication grants to use with this plugin and configure
    the `config.auth_methods` field accordingly.

    In order to restrict the scope of potential attacks, the parameter should only 
    contain the grants that you want to use. 

3. In many cases, you also need to specify `config.client_id`, and if your identity provider
    requires authentication, such as on a token endpoint, you will need to specify the client
    authentication credentials too, for example `config.client_secret`.

4. If you are using a public identity provider, such as Google, you should limit
    the audience with `config.audience_required` to contain only your `config.client_id`.
    You may also need to adjust `config.audience_claim` in case your identity provider
    uses a non-standard claim (other than `aud` as specified in JWT standard). This is
    important because some identity providers, such as Google, share public keys
    with different clients.

5. If you are using Kong in DB-less mode with a declarative configuration and 
    session cookie authentication, you should set `config.session_secret`.
    Leaving this parameter unset will result in every Nginx worker across your
    nodes encrypting and signing the cookies with their own secrets.

In summary, start with the following parameters:

1. `config.issuer`
2. `config.auth_methods`
3. `config.client_id` (and in many cases the client authentication credentials)
4. `config.audience_required` (if using a public identity provider)
5. `config.session_secret` (if using Kong in DB-less mode)

## Records

In the above parameter list, two configuration settings used an array of records as a data type:

- `config.client_jwk`: array of JWK records (one for each client)
- `config.session_redis_cluster_nodes`: array of host records, either as IP
addresses or hostnames, and their ports.

Below are descriptions of the record types.

### JWK Record

The JSON Web Key (JWK) record is specified in [RFC7517][jwk]. This record is used with the
`config.client_jwk` when using `private_key_jwk` client authentication.

Here is an example of JWK record generated by the plugin itself (see: [JSON Web Key Set](#json-web-key-set)):

```json
{{ page.jwk }}
```

The JWK private fields (`k`, `d`, `p`, `q`, `dp`, `dq`, `qi`, `oth`, `r`, `t`) are _referenceable_,
which means they can be securely stored as a
[secret](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

### Host Record

The Host record used with the `config.session_redis_cluster_nodes` is simple.
It contains `ip` or `host`, and the `port` where the `port` defaults to `6379`.

Here is an example of Host the record:

```json
{{ page.host }}
```

## Admin API

The OpenID Connect plugin extends the [Kong Admin API][admin] with a few endpoints.

[admin]: /gateway/latest/admin-api/

### Discovery Cache

When configuring the plugin using `config.issuer`, the plugin will store the fetched discovery
information to the Kong database, or in the worker memory with DB-less. The discovery cache does
not have an expiry or TTL, and so must be cleared manually using the `DELETE` endpoints listed below.

The discovery cache will attempt to be refreshed when a token is presented with required discovery 
information that is not already available, based on the `config.issuer` value. Once a rediscovery attempt 
has been made, a new attempt will not occur until the number of seconds defined in `rediscovery_lifetime` 
has elapsed - this avoids excessive discovery requests to the identity provider.
            
If a JWT cannot be validated due to missing discovery information and an invalid status code is 
received from the rediscovery request (for example, non-2xx), the plugin will attempt to validate the JWT
by falling back to any sufficient discovery information that is still in the discovery cache.

##### Discovery Cache Object

```json
{{ page.issuer_json }}
```

#### List All Discovery Cache Objects

<div class="endpoint get indent">/openid-connect/issuers</div>


##### Response

```
HTTP 200 OK
```

```json
{{ page.issuer_data }}
```

#### Retrieve Discovery Cache Object

<div class="endpoint get indent">/openid-connect/issuers/{issuer or id}</div>

{:.indent}
Attributes | Description
---:| ---
`issuer or id`<br>**required** | The unique identifier **or** the value of `config.issuer`

##### Response

```
HTTP 200 OK
```

```json
{{ page.issuer_json }}
```

#### Delete All Discovery Cache Objects

<div class="endpoint delete indent">/openid-connect/issuers</div>

##### Response

```
HTTP 204 No Content
```

{:.note}
> **Note:** The automatically generated session secret (that can be overridden with the
`config.session_secret`) is stored with the discovery cache objects. Deleting discovery cache
objects will invalidate all the sessions created with the associated secret.

#### Delete Discovery Cache Object

<div class="endpoint delete indent">/openid-connect/issuers/{issuer or id}</div>

{:.indent}
Attributes | Description
---:| ---
`issuer or id`<br>**required** | The unique identifier **or** the value of `config.issuer`

##### Response

```
HTTP 204 No Content
```

### JSON Web Key Set

When the OpenID Connect client (the plugin) is set to communicate with the identity provider endpoints
using `private_key_jwt`, the plugin needs to use public key cryptography. Thus, the plugin needs
to generate the needed keys. Identity provider on the other hand has to verify that the assertions
used for the client authentication.

The plugin will automatically generate the key pairs for the different algorithms. It will also
publish the public keys with the admin api where the identity provider could fetch them.

```json
{{ page.jwks }}
```

#### Retrieve JWKS

<div class="endpoint get indent">/openid-connect/jwks</div>

This endpoint will return a standard [JWK Set document][jwks] with the private keys stripped out.

##### Response

```
HTTP 200 OK
```

```json
{{ page.jwks }}
```

#### Rotate JWKS

<div class="endpoint delete indent">/openid-connect/jwks</div>

Deleting JWKS will also cause auto-generation of a new JWK set, so
`DELETE` will actually cause a key rotation.

##### Response

```
HTTP 204 No Content
```

[jwk]: https://datatracker.ietf.org/doc/html/rfc7517#section-4
[jwks]: https://datatracker.ietf.org/doc/html/rfc7517#appendix-A.1
[json-web-key-set]: #json-web-key-set


## Preparations

The OpenID Connect plugin relies in most cases on a third party identity provider.
In this section, we explain configuration of Keycloak and Kong.

All the `*.test` domains in the following examples point to the `localhost` (`127.0.0.1` and/or `::1`).

### Keycloak Configuration

We use [Keycloak][keycloak] as the identity provider in the following examples,
but the steps will be similar in other standard identity providers. If you encounter
difficulties during this phase, please refer to the [Keycloak documentation](https://www.keycloak.org/documentation).

1. Create a confidential client `kong` with `private_key_jwt` authentication and configure
   Keycloak to download the public keys from [the OpenID Connect Plugin JWKS endpoint][json-web-key-set]:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-kong-settings.png">
   <br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-kong-auth.png">
   <br>
2. Create a confidential client `service` with `client_secret_basic` authentication.
   For this client, Keycloak will auto-generate a secret similar to the following: `cf4c655a-0622-4ce6-a0de-d3353ef0b714`.
   Enable the client credentials grant for the client:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-service-settings.png">
   <br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-service-auth.png">
   <br>
{% if_version gte:3.5.x %}
3. Optional: Create another confidential client `cert-bound` with settings similar to the `service` client created previously.
   From the **Advanced** tab, enable the **OAuth 2.0 Mutual TLS Certificate Bound Access Tokens Enabled** toggle.
{% endif_version %}

4. Create a verified user with the name: `john` and the non-temporary password: `doe` that can be used with the password grant:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-user-john.png">

Alternatively you can [download the exported Keycloak configuration](/assets/images/products/plugins/openid-connect/keycloak.json),
and use it to configure the Keycloak. Please refer to [Keycloak import documentation](https://www.keycloak.org/docs/latest/server_admin/#_export_import)
for more information.

You need to modify Keycloak `standalone.xml` configuration file, and change the socket binding from:

```xml
<socket-binding name="https" port="${jboss.https.port:8443}"/>
```

to

```xml
<socket-binding name="https" port="${jboss.https.port:8440}"/>
```

The Keycloak default `https` port conflicts with the default Kong TLS proxy port,
and that can be a problem if both are started on the same host.

{% if_version gte:3.5.x %}
{:.note}
> **Note:** The mTLS proof of possession feature that validates OAuth 2.0 Mutual TLS Certificate Bound Access Tokens requires configuring Keycloak to validate client certificates using mTLS with the `--https-client-auth=request` option. For more information, see the [Keycloak documentation](https://www.keycloak.org/server/enabletls).
{% endif_version %}

[keycloak]: http://www.keycloak.org/

### Kong Configuration

#### Create a Service

```bash
http -f put :8001/services/openid-connect url=http://httpbin.org/anything
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd",
    "name": "openid-connect",
    "protocol": "http",
    "host": "httpbin.org",
    "port": 80,
    "path": "/anything"
}
```

#### Create a Route

```bash
http -f put :8001/services/openid-connect/routes/openid-connect paths=/
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "ac1e86bd-4bce-4544-9b30-746667aaa74a",
    "name": "openid-connect",
    "paths": [ "/" ]
}
```

#### Create a Plugin

You may execute this before patching the plugin (as seen on following examples) to reset
the plugin configuration.

```bash
http -f put :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  name=openid-connect                                          \
  service.name=openid-connect                                  \
  config.issuer=http://keycloak.test:8080/auth/realms/master   \
  config.client_id=kong                                        \
  config.client_auth=private_key_jwt
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
        "issuer": "http://keycloak.test:8080/auth/realms/master",
        "client_id": [ "kong" ],
        "client_auth": [ "private_key_jwt" ]
    }
}
```


> Also, check the discovery cache: `http :8001/openid-connect/issuers`.
> It should contain Keycloak OpenID Connect discovery document, and the keys.

#### Summary

At this point we have:

1. Created a Service
2. Routed traffic to the service
3. Enabled OpenID Connect plugin on the service

The following sections will guide you through the process of enabling the OpenID Connect
plugin for specific grants or flows.

## Authentication

Before you proceed, check that you have done [the preparations](#preparations).

We use [HTTPie](https://httpie.org/) to execute the examples. The output is stripped
for a better readability. [httpbin.org](https://httpbin.org/) is used as an upstream service.

Using Admin API is convenient when testing the plugin, but similar configs can
be done in declarative format as well.

When this plugin is configured with multiple grants/flows there is a hard-coded search
order for the credentials:

1. [Session Authentication](#session-authentication)
2. [JWT Access Token Authentication](#jwt-access-token-authentication)
3. [Kong OAuth Token Authentication](#kong-oauth-token-authentication)
4. [Introspection Authentication](#introspection-authentication)
5. [User Info Authentication](#user-info-authentication)
6. [Refresh Token Grant](#refresh-token-grant)
7. [Password Grant](#password-grant)
8. [Client Credentials Grant](#client-credentials-grant)
9. [Authorization Code Flow](#authorization-code-flow)

Once credentials are found, the plugin will stop searching further. Multiple grants may
share the same credentials. For example, both the password and client credentials grants can use 
basic access authentication through the `Authorization` header.

{:.warning}
> The choices made in the examples below are solely aimed at simplicity.
Because `httpbin.org` is used as an upstream service, it is highly recommended that you do
not run these usage examples with a production identity provider as there is a great chance
of leaking information. Also the examples below use the plain HTTP protocol that you should
never use in production. 

### Authorization Code Flow

The authorization code flow is the three-legged OAuth/OpenID Connect flow.
The sequence diagram below describes the participants and their interactions
for this usage scenario, including the use of session cookies:

![Authorization code flow diagram](/assets/images/products/plugins/openid-connect/authorization-code-flow.svg)

{:.note}
> If using PKCE, the identity provider *must* contain the `code_challenge_methods_supported` object in the `/.well-known/openid-configuration` issuer discovery endpoint response, as required by [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414.html). If it is not included, the PKCE `code_challenge` query parameter will not be sent.

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the authorization code flow and the session authentication.
2. We want to set the response mode to `form_post` so that authorization codes won't get logged to the access logs.
3. We want to preserve the original request query arguments over the authorization code flow redirection.
3. We want to redirect the client to original request url after the authorization code flow so that
   the `POST` request (because of `form_post`) is turned to the `GET` request, and the browser address bar is updated
   with the original request query arguments.
4. We don't want to include any tokens in the browser address bar.

[Reset the plugin configuration](#create-a-plugin) before patching.

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

#### Test the Authorization Code Flow

1. Open the Service Page with some query arguments:
   ```bash
   open http://service.test:8000/?hello=world
   ```
   <img src="/assets/images/products/plugins/openid-connect/authorization-code-flow-1.png">

2. See that the browser is redirected to the Keycloak login page:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/authorization-code-flow-2.png">
   <br>
   > You may examine the query arguments passed to Keycloak with the browser developer tools.
3. And finally you will be presented a response from httpbin.org:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/authorization-code-flow-3.png">
4. Done.

It looks rather simple from the user point of view, but what really happened is
described in [the diagram](#authorization-code-flow) above.

### Password Grant

Password grant is a legacy authentication grant. This is a less secure way of
authenticating end users than the authorization code flow, because, for example,
the passwords are shared with third parties. The image below illustrates the grant:

<img src="/assets/images/products/plugins/openid-connect/password-grant.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the password grant.
2. We want to search credentials for password grant from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.password_param_type=header
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
        "auth_methods": [ "password" ],
        "password_param_type": [ "header" ]
    }
}
```

#### Test the Password Grant

1. Request the service with basic authentication credentials created in the [Keycloak configuration](#keycloak-configuration) step:
   ```bash
   http -v -a john:doe :8000
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

> If you make another request using the same credentials, you should see that Kong adds less
> latency to the request as it has cached the token endpoint call to Keycloak.

### Client Credentials Grant

The client credentials grant is very similar to [the password grant](#password-grant).
The most important difference in the Kong OpenID Connect plugin is that the plugin itself
does not try to authenticate. It just forwards the credentials passed by the client
to the identity server's token endpoint. The client credentials grant is visualized
below:

<img src="/assets/images/products/plugins/openid-connect/client-credentials-grant.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the client credentials grant.
2. We want to search credentials for client credentials from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=client_credentials                         \
  config.client_credentials_param_type=header
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
        "auth_methods": [ "client_credentials" ],
        "client_credentials_param_type": [ "header" ]
    }
}
```

#### Test the Client Credentials Grant

1. Request the service with client credentials created in the [Keycloak configuration](#keycloak-configuration) step:
   ```bash
   http -v -a service:cf4c655a-0622-4ce6-a0de-d3353ef0b714 :8000
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Basic c2VydmljZTpjZjRjNjU1YS0wNjIyLTRjZTYtYTBkZS1kMzM1M2VmMGI3MTQ=
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

> If you make another request using the same credentials, you should see that Kong adds less
> latency to the request as it has cached the token endpoint call to Keycloak.

### Refresh Token Grant

The refresh token grant can be used when the client has a refresh token available. There is a caveat
with this: identity providers in general only allow refresh token grant to be executed with the same
client that originally got the refresh token, and if there is a mismatch, it may not work. The mismatch
is likely when Kong OpenID Connect is configured to use one client, and the refresh token is retrieved
with another. The grant itself is very similar to [password grant](#password-grant) and
[client credentials grant](#client-credentials-grant):

<img src="/assets/images/products/plugins/openid-connect/refresh-token-grant.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the refresh token grant, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the refresh token for the refresh token grant from the headers only.
3. We want to pass refresh token from the client in `Refresh-Token` header.
4. We want to pass refresh token to upstream in `Refresh-Token` header.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.refresh_token_param_name=refresh_token                  \
  config.refresh_token_param_type=header                         \
  config.auth_methods=refresh_token                              \
  config.auth_methods=password                                   \
  config.upstream_refresh_token_header=refresh_token
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
            "refresh_token",
            "password"
        ],
        "refresh_token_param_name": "refresh_token",
        "refresh_token_param_type": [ "header" ],
        "upstream_refresh_token_header": "refresh_token"
    }
}
```

The `config.auth_methods` and `config.upstream_refresh_token_header`
are only enabled for demoing purposes so that we can get a refresh token with:

```bash
http -a john:doe :8000 | jq -r '.headers."Refresh-Token"'
```
Output:
```
<refresh-token>
```

We can use the output in `Refresh-Token` header.

#### Test the Refresh Token Grant

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Refresh-Token:$(http -a john:doe :8000 | \
     jq -r '.headers."Refresh-Token"')
   ```
   or
   ```bash
   http -v :8000 Refresh-Token:"<refresh-token>"
   ```
   ```http
   GET / HTTP/1.1
   Refresh-Token: <refresh-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>",
           "Refresh-Token": "<refresh-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### JWT Access Token Authentication

For legacy reasons, the stateless `JWT Access Token` authentication is named `bearer` with the Kong
OpenID Connect plugin (see: `config.auth_methods`). Stateless authentication basically means
the signature verification using the identity provider published public keys and the standard
claims' verification (such as `exp` (or expiry)). The client may have received the token directly
from the identity provider or by other means. It is simple:

<img src="/assets/images/products/plugins/openid-connect/bearer-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the bearer authentication, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the bearer token for the bearer authentication from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=bearer                                     \
  config.auth_methods=password # only enabled for demoing purposes
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
            "bearer",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

The [password grant](#password-grant) is enabled so that we can get a JWT access token that we can use
to show how the JWT access token authentication works. That is: we need a token. One way to get a JWT access token
is to issue the following call (we use [jq](https://stedolan.github.io/jq/) to filter the response):

```bash
http -a john:doe :8000 | jq -r .headers.Authorization
```
Output:
```
Bearer <access-token>
```

We can use the output in `Authorization` header.

#### Test the JWT Access Token Authentication

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Authorization:"$(http -a john:doe :8000 | \
     jq -r .headers.Authorization)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### Introspection Authentication

As with [JWT Access Token Authentication](#jwt-access-token-authentication)), the introspection authentication
relies on a bearer token that the client has already gotten from somewhere. The difference to stateless
JWT authentication is that the plugin needs to call the introspection endpoint of the identity provider
to find out whether the token is valid and active. This makes it possible to issue opaque tokens to
the clients.

<img src="/assets/images/products/plugins/openid-connect/introspection-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the introspection authentication, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the bearer token for the introspection from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=introspection                              \
  config.auth_methods=password # only enabled for demoing purposes
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
            "introspection",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

#### Test the Introspection Authentication

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Authorization:"$(http -a john:doe :8000 | \
     jq -r .headers.Authorization)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### User Info Authentication

The user info authentication uses OpenID Connect standard user info endpoint to verify the access token.
In most cases it is preferable to use [Introspection Authentication](#introspection-authentication)
as that is meant for retrieving information from the token itself, whereas the user info endpoint is
meant for retrieving information about the user for whom the token was given. The sequence
diagram below looks almost identical to introspection authentication:

<img src="/assets/images/products/plugins/openid-connect/userinfo-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the user info authentication, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the bearer token for the user info from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=userinfo                                   \
  config.auth_methods=password # only enabled for demoing purposes
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
            "userinfo",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

#### Test the User Info Authentication

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Authorization:"$(http -a john:doe :8000 | \
     jq -r .headers.Authorization)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### Kong OAuth Token Authentication

The OpenID Connect plugin can also verify the tokens issued by [Kong OAuth 2.0 Plugin](/hub/kong-inc/oauth2/).
This is very similar to third party identity provider issued [JWT access token authentication](#jwt-access-token-authentication)
or [introspection authentication](#introspection-authentication):

<img src="/assets/images/products/plugins/openid-connect/kong-oauth-authentication.svg">

#### Prepare Kong OAuth Application

1. Create a Consumer:
   ```bash
   http -f put :8001/consumers/jane
   ```
2. Create Kong OAuth Application for the consumer:
   ```bash
   http -f put :8001/consumers/jane/oauth2/client \
     name=demo                                    \
     client_secret=secret                         \
     hash_secret=true
   ```
3. Create a Route:
   ```bash
   http -f put :8001/routes/auth paths=/auth
   ```
4. Apply OAuth plugin to the Route:
   ```bash
   http -f put :8001/plugins/7cdeaa2d-5faf-416d-8df5-533d1e4cd2c4 \
     name=oauth2                                                  \
     route.name=auth                                              \
     config.global_credentials=true                               \
     config.enable_client_credentials=true
   ```
5. Test the token endpoint:
   ```bash
   https -f --verify no post :8443/auth/oauth2/token \
     client_id=client                                \
     client_secret=secret                            \
     grant_type=client_credentials
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "access_token": "<access-token>",
       "expires_in": 7200,
       "token_type": "bearer"
   }
   ```

At this point we should be able to retrieve a new access token with:

```bash
https -f --verify no post :8443/auth/oauth2/token \
  client_id=client                                \
  client_secret=secret                            \
  grant_type=client_credentials |                 \
  jq -r .access_token
```
Output:
```
<access-token>
```

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the Kong OAuth authentication
2. We want to search the bearer token for the Kong OAuth authentication from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=kong_oauth2                                \
  config.bearer_token_param_type=header
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
        "auth_methods": [ "kong_oauth2" ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

#### Test the Kong OAuth Token Authentication

1. Request the service with Kong OAuth token:
   ```bash
   http -v :8000 Authorization:"Bearer $(https -f --verify no \
     post :8443/auth/oauth2/token                             \
     client_id=client                                         \
     client_secret=secret                                     \
     grant_type=client_credentials |                          \
     jq -r .access_token)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>",
           "X-Consumer-Id": "<consumer-id>",
           "X-Consumer-Username": "jane"
       },
       "method": "GET"
   }
   ```
2. Done.

### Session Authentication

Kong OpenID Connect plugin can issue a session cookie that can be used for further
session authentication. To make OpenID Connect issue a session cookie, you need
to first authenticate with one of the other grant / flows described above. In
[authorization code flow](#authorization-code-flow) we already demonstrated session
authentication when we used the redirect login action. The session authentication
is described below:

<img src="/assets/images/products/plugins/openid-connect/session-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the session authentication, but we also enable [the password grant](#password-grant) for demoing purposes

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=session                                    \
  config.auth_methods=password # only enabled for demoing purposes
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
            "session",
            "password"
        ]
    }
}
```

#### Test the Session Authentication

1. Request the service with basic authentication credentials (created in the [Keycloak configuration](#keycloak-configuration) step),
   and store the session:
   ```bash
   http -v -a john:doe --session=john :8000
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
   ```
   ```http
   HTTP/1.1 200 OK
   Set-Cookie: session=<session-cookie>; Path=/; SameSite=Lax; HttpOnly
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Make request with a session cookie (stored above):
   ```bash
   http -v --session=john :8000
   ```
   ```http
   GET / HTTP/1.1
   Cookie: session=<session-cookie>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
3. Done.

> If you want to disable session creation with some grants, you can use the `config.disable_session`.

## Authorization

Before you proceed, check that you have completed [the preparations](#preparations).

The OpenID Connect plugin has several features to do coarse grained authorization:

1. [Claims based authorization](#claims-based-authorization)
2. [ACL plugin authorization](#acl-plugin-authorization)
3. [Consumer authorization](#consumer-authorization)

### Claims Based Authorization

The following options can be configured to manage claims verification during authorization:

1. `config.scopes_claim` and `config.scopes_required`
2. `config.audience_claim` and `config.audience_required`
3. `config.groups_claim` and `config.groups_required`
4. `config.roles_claim` and `config.roles_required`

For example, the first configuration option, `config.scopes_claim`, points to a source, from which the value is
retrieved and checked against the value of the second configuration option: `config.scopes_required`.

Let's take a look at a JWT access token:

[Reset the plugin configuration](#create-a-plugin) before patching.

1. Patch the plugin to enable the password grant:
   ```bash
   http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
     config.auth_methods=password
   ```
2. Retrieve the content of an access token:
   ```bash
   http -a john:doe :8000 | jq -r .headers.Authorization
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```
   Bearer <access-token>
   ```
3. The signed JWT `<access-token>` (JWS) comes with three parts separated with a dot `.`:
   `<header>.<payload>.<signature>` (a JWS compact serialization format)
4. We are interested with the `<payload>`, and you should have something similar to:
   ```
   eyJleHAiOjE2MjI1NTY3MTMsImF1ZCI6ImFjY291bnQiLCJ0eXAiOiJCZWFyZXIiLC
   JzY29wZSI6Im9wZW5pZCBlbWFpbCBwcm9maWxlIiwicHJlZmVycmVkX3VzZXJuYW1l
   Ijoiam9obiIsImdpdmVuX25hbWUiOiJKb2huIiwiZmFtaWx5X25hbWUiOiJEb2UifQ
   ```
   That can be base64 url decoded to the following `JSON`:
   ```json
   {
       "exp": 1622556713,
       "aud": "account",
       "typ": "Bearer",
       "scope": "openid email profile",
       "preferred_username": "john",
       "given_name": "John",
       "family_name": "Doe"
   }
   ```
   This payload may contain arbitrary claims, such as user roles and groups,
   but as we didn't configure them in Keycloak, let's just use the claims that
   we have. In this case we want to authorize against the values in `scope` claim.

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the password grant for demonstration purposes.
2. We require the value `openid` and `email` to be present in `scope` claim of
   the access token.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.scopes_claim=scope                                      \
  config.scopes_required="openid email"
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
        "auth_methods": [ "password" ],
        "scopes_claim": [ "scope" ],
        "scopes_required": [ "openid email" ]
    }
}
```

Now let's see if we can still access the service:

```bash
http -v -a john:doe :8000
```
```http
GET / HTTP/1.1
Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
```
```http
HTTP/1.1 200 OK
```
```json
{
   "headers": {
       "Authorization": "Bearer <access-token>"
   },
   "method": "GET"
}
```

Works as expected, but let's try to add another authorization:

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.audience_claim=aud                                      \
  config.audience_required=httpbin
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
        "auth_methods": [ "password" ],
        "audience_claim": [ "scope" ],
        "audience_required": [ "httpbin" ]
    }
}
```

As we know, the access token has `"aud": "account"`, and that does not match with `"httpbin"`, so
the request should now be forbidden:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 403 Forbidden
```
```json
{
    "message": "Forbidden"
}
```

A few words about `config.scopes_claim` and `config.scopes_required` (and the similar configuration options).
You may have noticed that `config.scopes_claim` is an array of string elements. Why? It is used to traverse
the JSON when looking up a claim, take for example this imaginary payload:

```json
{
    "user": {
        "name": "john",
        "groups": [
            "employee",
            "marketing"
        ]
    }
}
```

In this case you would probably want to use `config.groups_claim` to point to `groups` claim, but that claim
is not a top-level claim, so you need to traverse there:

1. Find the `user` claim.
2. Inside the `user` claim, find the `groups` claim, and read its value:

```json
{
    "config": {
        "groups_claim": [
            "user",
            "groups"
        ]
    }
}
```

or

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.groups_claim=user                                       \
  config.groups_claim=groups
```

The value of a claim can be the following:

- a space separated string (such as `scope` claim usually is)
- an JSON array of strings (such as the imaginary `groups` claim above)
- a simple value, such as a `string`

What about the `config.groups_required` then? That is also an array?

That is correct, the required checks are arrays to allow logical `and`/`or` type of checks:

1. `and`: use a space separated values
2. `or`: specify value(s) in separate array indices


For example:

```json
{
    "config": {
        "groups_required": [
            "employee marketing",
            "super-admins"
        ]
    }
}
```

or

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.groups_required="employee marketing"                    \
  config.groups_required="super-admins"
```

The above means that a claim has to have:
1. `employee` **and** `marketing` values in it, **OR**
2. `super-admins` value in it

### ACL Plugin Authorization

The plugin can also be integrated with [Kong ACL Plugin](/hub/kong-inc/acl/) that provides
access control functionality in form of allow and deny lists.

Please read [the claims verification](#claims-verification) section for a basic information,
as a lot of that applies here too.

Let's first configure the OpenID Connect plugin for integration with the ACL plugin
(please remove other authorization if enabled):

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.authenticated_groups_claim=scope
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
        "auth_methods": [ "password" ],
        "authorized_groups_claim": [ "scope" ]
    }
}
```

Before we apply the ACL plugin, let's try it once:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "X-Authenticated-Groups": "openid, email, profile",
    }
}
```

Interesting, the `X-Authenticated-Groups` header was injected in a request.
This means that we are all good to add the ACL plugin:

```bash
http -f put :8001/plugins/b238b64a-8520-4bbb-b5ff-2972165cf3a2 \
  name=acl                                                     \
  service.name=openid-connect                                  \
  config.allow=openid
```

Let's test it again:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```

Let's make it forbidden by changing it to a deny-list:

```bash
http -f patch :8001/plugins/b238b64a-8520-4bbb-b5ff-2972165cf3a2 \
  config.allow=                                                  \
  config.deny=profile
```

And try again:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 403 Forbidden
```
```json
{
    "message": "You cannot consume this service"
}
```

### Consumer Authorization

The third option for authorization is to use Kong consumers and dynamically map
from a claim value to a Kong consumer. This means that we restrict the access to
only those that do have a matching Kong consumer. Kong consumers can have ACL
groups attached to them and be further authorized with the
[Kong ACL Plugin](/hub/kong-inc/acl/).

As a remainder our token payload looks like this:
```json
{
   "exp": 1622556713,
   "aud": "account",
   "typ": "Bearer",
   "scope": "openid email profile",
   "preferred_username": "john",
   "given_name": "John",
   "family_name": "Doe"
}
```

Out of these the `preferred_username` claim looks promising for consumer mapping.
Let's patch the plugin:

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.consumer_claim=preferred_username                       \
  config.consumer_by=username
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
        "auth_methods": [ "password" ],
        "consumer_claim": [ "preferred_username" ],
        "consumer_by": [ "username" ]
    }
}
```

Before we proceed, let's make sure we don't have consumer `john`:

```bash
http delete :8001/consumers/john
```
```http
HTTP/1.1 204 No Content
```

Let's try to access the service without a matching consumer:

```bash
http -a john:doe :8000
```
```http
HTTP/1.1 403 Forbidden
```
```json
{
    "message": "Forbidden"
}
```

Now, let's add the consumer:

```bash
http -f put :8001/consumers/john
```
```http
HTTP/1.1 200 OK
```
```json

{
    "id": "<consumer-id>",
    "username": "john"
}
```

Let's try to access the service again:

```bash
http -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "Authorization": "Bearer <access-token>",
        "X-Consumer-Id": "<consumer-id>",
        "X-Consumer-Username": "john"
    },
    "method": "GET"
}
```

Nice, as you can see the plugin even added the `X-Consumer-Id` and `X-Consumer-Username` as request headers.

> It is possible to make consumer mapping optional and non-authorizing by setting the `config.consumer_optional=true`.

{% if_version gte:3.5.x %}
## Certificate-Bound Access Tokens

One of the main vulnerabilities of OAuth are bearer tokens because presenting a valid bearer token is enough proof to access a resource. This can create problems since the client presenting the token isn't validated as the legitimate user that the token was issued to. 

Certificate-bound access tokens can solve this problem by binding tokens to clients. This ensures the legitimacy of the token because it requires proof that the sender is authorized to use a particular token to access protected resources. 

To enable certificate-bound access for OpenID Connect, it is necessary to ensure that the Auth server is configured to generate OAuth 2.0 Mutual TLS Certificate Bound Access Tokens. The Certificate Authority should be trusted by both the Auth server and Kong.
For configuring this in Keycloak, refer to the [Keycloak configuration](#keycloak-configuration) section above.
For alternative auth servers, consult their documentation to configure this functionality.

Some of the instructions in the previous sections support validation of access tokens using mTLS proof of possession.
Enabling the `proof_of_possession_mtls` configuration option in the plugin ensures that the supplied access token
belongs to the client by verifying its binding with the client certificate provided in the request.

The certificate-bound access tokens are supported by the following methods:

- [JWT Access Token Authentication](#jwt-access-token-authentication)
- [Introspection Authentication](#introspection-authentication)
- [Session Authentication](#session-authentication)

    {:.note}
    > **Note:** Session Authentication is only compatible with certificate-bound access tokens when used along with one of the other supported authentication methods. When the configuration option `proof_of_possession_auth_methods_validation` is set to `false` and other non-compatible methods are enabled, if a valid session is found, the proof of possession validation will only be performed if the session was originally created using one of the compatible methods. If multiple `openid-connect` plugins are configured with the `session` auth method, we strongly recommend configuring different values of `config.session_secret` across plugins instances for additional security. This avoids sessions being shared across plugins and possibly bypassing the proof of possession validation.

{:.note}
> **Note:** The mTLS proof of possession feature relies on mutual TLS to be enabled in Kong. For more information refer to the [TLS Handshake Modifier plugin](/hub/kong-inc/tls-handshake-modifier/) or the [Mutual TLS Authentication plugin](/hub/kong-inc/mtls-auth/) documentation.

The following example shows how to enable this feature for the JWT Access Token Authentication method. Similar steps can be followed for the other methods.

1. Configure {{site.base_gateway}} to use mTLS client certificate authentication. This example uses the [TLS Handshake Modifier plugin](/hub/kong-inc/tls-handshake-modifier/):

    ```bash
    http -f post :8001/plugins    \
    name=tls-handshake-modifier \
    service.name=openid-connect
    ```
    If this is configured correctly, a `200` status code is returned, and a response similar to the following:
    ```json
    {
        "id": "a7f676e6-580d-4841-80de-de46e1f79eb2",
        "name": "tls-handshake-modifier",
        "service": {
            "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
        }
    }
    ```

2. To enable certificate-bound access tokens, use the `proof_of_possession_mtls` configuration option:

    ```bash
    http -f put :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
    name=openid-connect                                          \
    service.name=openid-connect                                  \
    config.issuer=https://keycloak.test:8440/auth/realms/master  \
    config.client_id=cert-bound                                  \
    config.client_secret=cf4c655a-0622-4ce6-a0de-d3353ef0b714    \
    config.auth_methods=bearer                                   \
    config.proof_of_possession_mtls=strict
    ```
    If this is configured correctly, a `200` status code is returned, and a response similar to the following:
    ```json
    {
        "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
        "name": "openid-connect",
        "service": {
            "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
        },
        "config": {
            "issuer": "https://keycloak.test:8440/auth/realms/master",
            "client_id": [ "cert-bound" ],
            "client_secret": [ "cf4c655a-0622-4ce6-a0de-d3353ef0b714" ],
            "auth_methods": [ "bearer" ],
            "proof_of_possession_mtls": "strict",
        }
    }
    ```

3. Obtain the token from the IdP, making sure to modify the following command appropriately:
    ```bash
    http --cert client-cert.pem --cert-key client-key.pem                                 \
    -f post https://keycloak.test:8440/auth/realms/master/protocol/openid-connect/token \
    client_id=cert-bound                                                                \
    client_secret=cf4c655a-0622-4ce6-a0de-d3353ef0b714                                  \
    grant_type=client_credentials
    ```
    If this is configured correctly, a `200` status code is returned, and a response similar to the following:
    ```json
    {
        "access_token": "eyJhbG...",
    }
    ```

    The token obtained should include a claim that consists of the hash of the client certificate:
    ```json
    {
        "exp": 1622556713,
        "typ": "Bearer",
        "cnf": {
            "x5t#S256": "hh_XBS..."
        }
    }
    ```

4. Access the service using the same client certificate and key used to obtain the token:
    ```bash
    http --cert client-cert.pem --cert-key client-key.pem \
    -f post https://kong.test:8443                      \
    Authorization:"Bearer eyJhbGc..."
    ```
    If this is configured correctly, it returns a `200` status code:
    ```http
    HTTP/1.1 200 OK
    ```
{% endif_version %}
## Headers

Before you proceed, check that you have completed [the preparations](#preparations).

The OpenID Connect plugin can pass claim values, tokens, JWKs, and the session identifier to the upstream service
in request headers, and to the downstream client in response headers. By default, the plugin passes an access token
in `Authorization: Bearer <access-token>` header to the upstream service (this can be controlled with
`config.upstream_access_token_header`). The claim values can be taken from:
- an access token,
- an id token,
- an introspection response, or
- a user info response

Let's take a look for an access token payload:

```json
{
   "exp": 1622556713,
   "aud": "account",
   "typ": "Bearer",
   "scope": "openid email profile",
   "preferred_username": "john",
   "given_name": "John",
   "family_name": "Doe"
}
```

To pass the `preferred_username` claim's value `john` to the upstream with an `Authenticated-User` header,
we need to patch our plugin:

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.upstream_headers_claims=preferred_username              \
  config.upstream_headers_names=authenticated_user
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
        "auth_methods": [ "password" ],
        "upstream_headers_claims": [ "preferred_username" ],
        "upstream_headers_names": [ "authenticated_user" ]
    }
}
```

Let's see if it had any effect:

```bash
http -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "Authorization": "Bearer <access-token>",
        "Authenticated-User": "john"
    },
    "method": "GET"
}
```

See the [configuration parameters](#parameters) for other options.

## Logout

The logout functionality is mostly useful together with [session authentication](#session-authentication)
that is mostly useful with [authorization code flow](#authorization-code-flow).

As part of the logout, the OpenID Connect plugin implements several features:

- session invalidation
- token revocation
- relying party (RP) initiated logout

Let's patch the OpenID Connect plugin to provide the logout functionality:

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=session                                    \
  config.auth_methods=password                                   \
  config.logout_uri_suffix=/logout                               \
  config.logout_methods=POST                                     \
  config.logout_revoke=true
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
        "auth_methods": [ "password", "session" ],
        "logout_uri_suffix": "/logout",
        "logout_methods": [ "POST" ],
        "logout_revoke": true
    }
}
```

Login and establish a session:

```bash
http -a john:doe --session=john :8000
```
```http
HTTP/1.1 200 OK
```

Test that session authentication works:

```bash
http --session=john :8000
```
```http
HTTP/1.1 200 OK
```

Logout, and follow the redirect:

```bash
http --session=john --follow -a john: post :8000/logout
```
```http
HTTP/1.1 200 OK
```

> We needed to pass `-a john:` as there seems to be a feature with `HTTPie`
> that makes it to store the original basic authentication credentials in
> a session - not just the session cookies.

At this point the client has logged out from both Kong and the identity provider (Keycloak).

Check that the session is really gone:

```bash
http --session=john :8000
```
```http
HTTP/1.1 401 Unauthorized
```

## Debugging

The OpenID Connect plugin is complex, integrating with third-party identity providers can present challenges. If you have
issues with the plugin or integration, try the following:

1. Set Kong [log level](/gateway/latest/reference/configuration/#log_level) to `debug`, and check the Kong `error.log` (you can filter it with `openid-connect`)
   ```bash
   KONG_LOG_LEVEL=debug kong restart
   ```
2. Set the Kong OpenID Connect plugin to display errors:
   ```json
   {
       "config": {
           "display_errors": true
       }
   }
   ```
3. Disable the Kong OpenID Connect plugin verifications and see if you get further, just for debugging purposes:
   ```json
   {
       "config": {
           "verify_nonce": false,
           "verify_claims": false,
           "verify_signature": false
       }
   }
   ```
4. See what kind of tokens the Kong OpenID Connect plugin gets:
   ```json
   {
       "config": {
           "login_action": "response",
           "login_tokens": [ "tokens" ],
           "login_methods": [
               "password",
               "client_credentials",
               "authorization_code",
               "bearer",
               "introspection",
               "userinfo",
               "kong_oauth2",
               "refresh_token",
               "session"
           ]
       }
   }
   ```

With session related issues, you can try to store the session data in `Redis` or `memcache` as that will make the session
cookie much smaller. It is rather common that big cookies do cause issues. You can also enable session
compression.

Also try to eliminate indirection as that makes it easier to find out where the problem is. By indirection, we
mean other gateways, load balancers, NATs, and such in front of Kong. If there is such, you may look at using:

- [port maps](/gateway/latest/reference/configuration/#port_maps)
- `X-Forwarded-*` headers

