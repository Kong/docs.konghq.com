---
nav_title: OpenID Connect API

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

## Admin API

The OpenID Connect plugin extends the [Kong Admin API](/gateway/latest/admin-api/) with a few endpoints.

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

