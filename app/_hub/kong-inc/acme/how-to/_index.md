---
nav_title: Getting started with ACME
---

## Using the plugin

### Prerequisites

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
          - name: http
        paths:
          - /.well-known/acme-challenge
plugins:
  - name: acme
    config:
      account_email: example@myexample.com
      account_key:
        key_id: "1234"
        key_set: "example-key-set"
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

{% if_plugin_version gte:3.3.x %}

Here is another example that uses a `key_id` and `key_set` to configure the `account_key`:

```yaml
_format_version: "3.0"
# this section is not necessary if there's already a route that matches
# /.well-known/acme-challenge path with http protocol
key_sets:
  name: example-key-set
keys:
  example-key:
    set: example-key-set
    pem:
      private_key: {vault://env/example-private-key}
services:
  - name: acme-dummy
    url: http://127.0.0.1:65535
    routes:
      - name: acme-dummy
        protocols:
          - name: http
        paths:
          - /.well-known/acme-challenge
plugins:
  - name: acme
    config:
      account_email: example@myexample.com
      account_key:
        key_id: example-key
        key_set: example-key-set
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

{% endif_plugin_version %}

### Enable the plugin

For each the domain that needs a certificate, make sure `DOMAIN/.well-known/acme-challenge`
is mapped to a route in Kong. You can check this by sending
`curl KONG_IP/.well-known/acme-challenge/x -H "host:DOMAIN"` and getting the response `Not found`.
You can also [use the Admin API](/hub/kong-inc/acme/reference/api/#create-certificates) to verify the setup.
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
[Parameters](/hub/kong-inc/acme/configuration/) section.

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

## More information

* [Local testing and development guide](/hub/kong-inc/how-to/local-testing-development/)
* Monitoring and debugging: The ACME plugin exposes monitoring and debuggin endpoints 
through the {{site.base_gateway}} Admin API. See the 
[ACME API reference](/hub/kong-inc/acme/reference/api/) for more information.
* [ACME plugin configuration reference](/hub/kong-inc/acme/configuration/) and 
[basic configuration examples](/hub/kong-inc/acme/configuration/examples/)

