---
name: ACME
publisher: Kong Inc.
desc: Let's Encrypt and ACMEv2 integration with Kong
description: |
  This plugin allows Kong to apply certificates from Let's Encrypt or any other ACMEv2 service and serve them dynamically.
  Renewal is handled with a configurable threshold time.
type: plugin
categories:
  - security
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
params:
  name: acme
  service_id: false
  route_id: false
  consumer_id: false
  protocols:
    - http
    - https
    - tcp
    - tls
    - grpc
    - grpcs
  dbless_compatible: 'yes'
  config:
    - name: account_email
      required: 'yes'
      default: null
      value_in_examples: example@example.com
      encrypted: true
      datatype: string
      referenceable: true
      description: |
        The account identifier. Can be reused in a different plugin instance.
    - name: api_uri
      required: false
      default: '` https://acme-v02.api.letsencrypt.org/directory`'
      datatype: string
      description: |
        The ACMEv2 API endpoint to use. You can specify the
        [Let's Encrypt staging environment](https://letsencrypt.org/docs/staging-environment/) for testing. Kong doesn't automatically delete staging certificates. If you use the same domain in test and production environments, you need to manually delete those certificates after testing.
    - name: cert_type
      required: false
      default: '`rsa`'
      datatype: string
      description: |
        The certificate type to create. The possible values are `"rsa"` for RSA certificate or `"ecc"` for EC certificate.
    - name: domains
      required: false
      default: '`[]`'
      datatype: array of string elements
      description: |
        The list of domains to create certificates for. To match subdomains under `example.com`, use `*.example.com`.
        Regex pattern is not supported.

        This parameter is only used to match domains, not to specify the Common Name
        or Subject Alternative Name to create certificates. Each domain must have its own certificate.
        The ACME plugin checks this configuration before checking any certificate in `storage` when serving the certificate of a request.

        If this field is left empty, all top-level domains (TLDs) are allowed.
    - name: allow_any_domain
      minimum_version: "3.0.x"
      required: false
      default: false
      datatype: boolean
      description: |
        If set to `true`, the plugin allows all domains and ignores any values in the `domains` list.
    - name: fail_backoff_minutes
      minimum_version: "2.1.x"
      required: false
      default: 5
      datatype: number
      description: |
        Minutes to wait for each domain that fails to create a certificate. This applies to both a
        new certificate and a renewal certificate.
    - name: renew_threshold_days
      required: false
      default: '`14`'
      datatype: number
      description: |
        Days remaining to renew the certificate before it expires.
    - name: storage
      required: false
      default: '`shm`'
      datatype: string
      description: |
        The backend storage type to use. The possible values are `"kong"`, `"shm"`, `"redis"`, `"consul"`, or `"vault"`. In DB-less mode, `"kong"` storage is unavailable. Note that `"shm"` storage does not persist during Kong restarts and does not work for Kong running on different machines, so consider using one of `"kong"`, `"redis"`, `"consul"`, or `"vault"` in production. Please refer to the Hybrid Mode sections below as well.
    - name: storage_config
      required: false
      default: null
      datatype: record
      description: |
        Storage configs for each backend storage. See [Storage configuration considerations](#storage-config)
        for information on its default values.
    - name: tos_accepted
      required: false
      default: '`false`'
      datatype: boolean
      description: |
        If you are using Let's Encrypt, you must set this to `true` to agree the [Terms of Service](https://letsencrypt.org/repository/).
    - name: eab_kid
      minimum_version: "2.4.x"
      required: false
      datatype: string
      encrypted: true
      referenceable: true
      description: |
        External account binding (EAB) key id. You usually don't need to set this unless it is explicitly required by the CA.
    - name: eab_hmac_key
      minimum_version: "2.4.x"
      required: false
      datatype: string
      encrypted: true
      referenceable: true
      description: |
        External account binding (EAB) base64-encoded URL string of the HMAC key. You usually don't need to set this unless it is explicitly required by the CA.
    - name: rsa_key_size
      minimum_version: "2.8.x"
      required: false
      datatype: number
      default: 4096
      description: |
        RSA private key size for the certificate. The possible values are 2048, 3072, or 4096.
---

{% if_plugin_version gte:2.4.x %}

## EAB support

External account binding (EAB) is supported as long as `eab_kid` and `eab_hmac_key` are provided.

The following CA provider's external account can be registered automatically, without specifying
the `eab_kid` or `eab_hmac_key`:

- [ZeroSSL](https://zerossl.com/)

{% endif_plugin_version %}

## Storage configuration considerations {#storage-config}

`config.storage_config` is a table for all possible storage types. By default, it is:

```json
    "storage_config": {
      "kong": {},
      "shm": {
        "shm_name": "kong"
      },
      "redis": {
        "auth": null,
        "port": 6379,
        "database": 0,
        "host": "127.0.0.1"
      },
       "consul": {
          "host": "127.0.0.1",
          "port": 8500,
          "token": null,
          "kv_path": "acme",
          "timeout": 2000,
          "https": false
      },
      "vault": {
          "host": "127.0.0.1",
          "port": 8200,
          "token": null,
          "kv_path": "acme",
          "timeout": 2000,
          "https": false,
          "tls_verify": true,
          "tls_server_name": null,
          "auth_method": "token",
          "auth_path": null,
          "auth_role": null,
          "jwt_path": null,
      },
    }
```

The `consul.token`, `redis.auth`, and `vault.token` fields are _referenceable_, which means they can be securely stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format).

To configure a storage type other than `kong`, refer to [lua-resty-acme](https://github.com/fffonion/lua-resty-acme#storage-adapters).

## Workflow

A `http-01` challenge workflow between the {{site.base_gateway}} and the ACME server is described below:

1. The client sends a proxy or Admin API request that triggers certificate generation for `mydomain.com`.
2. The {{site.base_gateway}} sends a request to the ACME server to start the validation process.
3. The ACME server returns a challenge response detail to the {{site.base_gateway}}.
4. `mydomain.com` is publicly resolvable to the {{site.base_gateway}} that serves the challenge response.
5. The ACME server checks if the previous challenge has a response at `mydomain.com`.
6. The {{site.base_gateway}} checks the challenge status and if passed, downloads the certificate from the ACME server.
7. The {{site.base_gateway}} uses the new certificate to serve TLS requests.


## Using the plugin

### Configure Kong

- Kong needs to listen on port 80 or proxy a load balancer that listens for port 80.
- `lua_ssl_trusted_certificate` needs to be set in `kong.conf` to ensure the plugin can properly
verify the Let's Encrypt API. The CA-bundle file is usually `/etc/ssl/certs/ca-certificates.crt` for
Ubuntu/Debian and `/etc/ssl/certs/ca-bundle.crt` for CentOS/Fedora/RHEL. Starting with Kong v2.2,
users can set this config to `system` to auto pick CA-bundle from OS.

### Configure plugin

Here's a sample declarative configuration with `redis` as storage:

```yaml
_format_version: "3.0"
# this section is not necessary if there's already a route that matches
# /.well-known/acme-challenge path with http protocol
services:
  - name: acme-dummy
    url: http://127.0.0.1:65535
    routes:
      - name: acme-dummy
        protocols:
          - http
        paths:
          - /.well-known/acme-challenge
plugins:
  - name: acme
    config:
      account_email: example@myexample.com
      domains:
        - "*.example.com"
        - "example.com"
      tos_accepted: true
      storage: redis
      storage_config:
        redis:
          host: redis.service
          port: 6379
```

### Enable the plugin

For each the domain that needs a certificate, make sure `DOMAIN/.well-known/acme-challenge`
is mapped to a route in Kong. You can check this by sending
`curl KONG_IP/.well-known/acme-challenge/x -H "host:DOMAIN"` and getting the response `Not found`.
You can also [use the Admin API](#create-certificates) to verify the setup.
If not, add a route and a dummy service to catch this route.

```bash
# add a dummy service if needed
curl http://localhost:8001/services \
  -d name=acme-dummy \
  -d url=http://127.0.0.1:65535

# add a dummy route if needed
curl http://localhost:8001/routes \
  -d name=acme-dummy \
  -d paths[]=/.well-known/acme-challenge \
  -d service.name=acme-dummy

# add the plugin
curl http://localhost:8001/plugins \
  -d name=acme \
  -d config.account_email=yourname@yourdomain.com \
  -d config.tos_accepted=true \
  -d config.domains[]=my.secret.domains.com
```

Note by setting `tos_accepted` to *true* implies that you have read and accepted
[terms of service](https://letsencrypt.org/repository/).

**This plugin can only be configured as a global plugin.** The plugin terminates
`/.well-known/acme-challenge/` path for matching domains. To create certificates
and terminate challenges only for certain domains, refer to the
[Parameters](#parameters) section.

### Trigger certificate creation

Assume Kong proxy is accessible via http://mydomain.com and https://mydomain.com.

```bash
# Trigger asynchronous creation from proxy requests
# The following request returns immediately with Kong's default certificate
# Wait up to 1 minute for the background process to finish
curl https://mydomain.com -k

# OR create from Admin API synchronously
# User can also use this endpoint to force "renew" a certificate
curl http://localhost:8001/acme -d host=mydomain.com

# Furthermore, it's possible to run a sanity test on your Kong setup
# before creating any certificate
curl http://localhost:8001/acme -d host=mydomain.com -d test_http_challenge_flow=true

curl https://mydomain.com
# Now gives you a valid Let's Encrypt certicate
```

### Renew certificates

The plugin runs daily checks and automatically renews all certificates that
will expire in less than the configured `renew_threshold_days` value. If the renewal
of an individual certificate throws an error, the plugin will continue renewing the
other certificates. It will try renewing all certificates, including those that previously
failed, once per day. Note the renewal configuration is stored in the configured storage backend.
If the storage is cleared or modified outside of Kong, renewal might not complete properly.

It's also possible to actively trigger the renewal. The following request
schedules a renewal in the background and returns immediately.

```bash
curl http://localhost:8001/acme -XPATCH
```

## Monitoring and debugging

The ACME plugin exposes several endpoints through Admin API that can be used for
debugging and monitoring certificate creation and renewal.

### Apply certificate

**Endpoint**

<div class="endpoint post">/acme</div>
Applies or renews the certificate and returns the result.

**Request body**

Attribute | Description
---:| ---
`host`<br>*required* | The domain where to create the certificate.
`test_http_challenge_flow`<br>*optional* | When set, only checks if the configuration is valid. Does not apply the certificate.

### Update certificate

Apply or renew the certificate and return the result. Unlike `POST`, `PATCH` runs the process in the background.

**Endpoint**

<div class="endpoint patch">/acme</div>

**Request body**

Attribute | Description
---:| ---
`host`<br>*required* | The domain where to create the certificate.
`test_http_challenge_flow`<br>*optional* | When set, only checks if the configuration is valid. Does not apply the certificate.

### Get ACME certificates

List the certificates being created by the ACME plugin. You can use this endpoint to monitor certificate existence and expiry.

**Endpoint**
<div class="endpoint get">/acme/certificates</div>

### Get certificate by host

List certificates with a specific host.

**Endpoint**
<div class="endpoint get">/acme/certificates/{HOST}</div>

Attribute | Description
---:| ---
`HOST` | The IP or hostname of the host to target.

Example response for listing certificates:

```json
{
  "data": [
    {
      "not_after": "2022-09-21 23:59:59",
      "pubkey_type": "id-ecPublicKey",
      "digest": "A9:49:55:06:A7:B6:1D:2B:13:47:C5:58:5B:AC:DA:43:B5:25:E0:86",
      "issuer_cn": "ZeroSSL ECC Domain Secure Site CA",
      "valid": true,
      "host": "subdomain1.domain.com",
      "not_before": "2022-06-23 00:00:00",
      "serial_number": "93:B8:E9:D5:C6:36:ED:B4:A8:B3:FD:C5:9E:A8:08:88"
    },
    {
      "not_after": "2022-09-21 23:59:59",
      "pubkey_type": "id-ecPublicKey",
      "digest": "26:12:A2:C4:6A:F5:A5:90:9D:03:15:CB:FE:A7:BF:32:1C:42:49:CE",
      "issuer_cn": "ZeroSSL ECC Domain Secure Site CA",
      "valid": true,
      "host": "subdomain2.domain.com",
      "not_before": "2022-06-23 00:00:00",
      "serial_number": "F1:15:74:E3:E1:DD:21:72:48:C0:4F:06:25:1B:71:F7"
    }
  ]
}
```

## Hybrid mode

`"shm"` storage type is not available in Hybrid Mode.

Due to current the limitations of Hybrid Mode, `"kong"` storage only supports certificate generation from
the Admin API but not the proxy side.

`"kong"` storage in Hybrid Mode works in following flow:

1. The client sends an Admin API request that triggers certificate generation for `mydomain.com`.
2. The Kong Control Plane requests the ACME server to start the validation process.
3. The ACME server returns a challenge response detail to the Kong Control Plane.
4. The Kong Control Plane propagates the challenge response detail to the Kong Data Plane.
5. `mydomain.com` is publicly resolvable to the Kong Data Plane that serves the challenge response.
6. The ACME server checks if the previous challenge has a response at `mydomain.com`.
7. The Kong Control Plane checks the challenge status and if passed, downloads the certificate from the ACME server.
8. The Kong Control Plane propagates the new certificates to the Kong Data Plane.
9. The Kong Data Plane uses the new certificate to serve TLS requests.

All external storage types work as usual in Hybrid Mode. Note both the Control Plane and Data Planes
need to connect to the same external storage cluster. It's also a good idea to setup replicas to avoid
connecting to same node directly for external storage.

External storage in Hybrid Mode works in following flow:

1. The client send a proxy or Admin API request that triggers certificate generation for `mydomain.com`.
2. The Kong Control Plane or Data Plane requests the ACME server to start the validation process.
3. The ACME server returns a challenge response detail to the {{site.base_gateway}}.
4. The Kong Control Plane or Data Plane stores the challenge response detail in external storage.
5. `mydomain.com` is publicly resolvable to the Kong Data Plane that reads and serves the challenge response from external storage.
6. The ACME server checks if the previous challenge has a response at `mydomain.com`.
7. The Kong Control Plane or Data Plane checks the challenge status and if passed, downloads the certificate from the ACME server.
8. The Kong Control Plane or Data Plane stores the new certificates in external storage.
9. The Kong Data Plane reads from external storage and uses the new certificate to serve TLS requests.

## Local testing and development

### Run ngrok

[ngrok](https://ngrok.com) exposes a local URL to the internet. [Download ngrok](https://ngrok.com/download) and install.

*`ngrok` is only needed for local testing or development, it's **not** a requirement for the plugin itself.*

Run ngrok with:

```bash
./ngrok http localhost:8000
# Shows something like
# ...
# Forwarding                    http://e2e034a5.ngrok.io -> http://localhost:8000
# Forwarding                    https://e2e034a5.ngrok.io -> http://localhost:8000
# ...
# Substitute "e2e034a5.ngrok.io" with the host shows in your ngrok output
export NGROK_HOST=e2e034a5.ngrok.io
```

Leave the process running.

### Configure route and service

```bash
curl http://localhost:8001/services \
  -d name=acme-test \
  -d url=http://mockbin.org

curl http://localhost:8001/routes \
  -d service.name=acme-test \
  -d hosts=$NGROK_HOST \
  -d paths=/mock
```

### Enable plugin

```bash
curl localhost:8001/plugins \
  -d name=acme \
  -d config.account_email=test@test.com \
  -d config.tos_accepted=true \
  -d config.domains[]=$NGROK_HOST
```

### Trigger certificate creation

```bash
curl https://$NGROK_HOST:8443 --resolve $NGROK_HOST:8443:127.0.0.1 -vk
# Wait for several seconds
```

### Check new certificate

```bash
echo q |openssl s_client -connect localhost -port 8443 -servername $NGROK_HOST 2>/dev/null |openssl x509 -text -noout
```

## Notes

- In database mode, the plugin creates an SNI and Certificate entity in Kong to
serve the certificate. If SNI or Certificate for the current request is already set
in the database, they will be overwritten.
- In DB-less mode, the plugin takes over certificate handling. If the SNI or
Certificate entity is already defined in Kong, they will be overridden by the
response.
- The plugin only supports http-01 challenge, meaning a user will need a public
IP and set up a resolvable DNS. Kong also needs to accept proxy traffic from port `80`.
Also, note that a wildcard or star (`*`) certificate is not supported. Each domain must have its
own certificate.

---

## Changelog

{% if_plugin_version gte:3.0.x %}

**{{site.base_gateway}} 3.0.x**
* The `storage_config.vault.auth_method` configuration parameter now defaults to `token`.
* Added the `allow_any_domain` configuration parameter. If enabled, it lets {{site.base_gateway}}
  ignore the `domains` field.

{% endif_plugin_version %}

{% if_plugin_version gte:2.8.x %}
**{{site.base_gateway}} 2.8.x**

* Added the `rsa_key_size` configuration parameter.
* The `consul.token`, `redis.auth`, and `vault.token` are now marked as now marked as
referenceable, which means they can be securely stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started) in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format).

{% endif_plugin_version %}

{% if_plugin_version gte:2.7.x %}
**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `account_email`, `eab_kid`, and `eab_hmac_kid` parameter values will be
 encrypted.

{% endif_plugin_version %}

{% if_plugin_version gte:2.4.x %}
**{{site.base_gateway}} 2.4.x**
* Added external account binding (EAB) support with the `eab_kid` and `eab_hmac_key` configuration parameters.

{% endif_plugin_version %}

**{{site.base_gateway}} 2.1.x**
* Added the `fail_backoff_minutes` configuration parameter.
