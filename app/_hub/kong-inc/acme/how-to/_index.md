---
nav_title: Getting started with ACME
title: Getting started with ACME
---

## Using the plugin

You can follow the [basic examples](/hub/kong-inc/acme/how-to/basic-example/) to enable
your plugin using your preferred method. Or, follow this guide to set up and 
test the plugin from start to finish.

### Prerequisites

- Kong needs to listen on port 80 or proxy a load balancer that listens for port 80.
- `lua_ssl_trusted_certificate` needs to be set in `kong.conf` to ensure the plugin can properly
verify the Let's Encrypt API. The CA-bundle file is usually `/etc/ssl/certs/ca-certificates.crt` for
Ubuntu/Debian and `/etc/ssl/certs/ca-bundle.crt` for CentOS/Fedora/RHEL. Starting with Kong v2.2,
users can set this config to `system` to auto pick CA-bundle from OS.

### Getting started with the ACME plugin

For each the domain that needs a certificate, make sure `DOMAIN/.well-known/acme-challenge`
is mapped to a route in Kong. You can check this by sending
`curl KONG_IP/.well-known/acme-challenge/x -H "host:DOMAIN"` and getting the response `Not found`.
You can also [use the Admin API](/hub/kong-inc/acme/api/#create-certificates) to verify the setup.
If not, add a route and a dummy service to catch this route.

1. Add a sample service if needed:

    ```sh
    curl http://localhost:8001/services \
      -d name=acme-example \
      -d url=http://127.0.0.1:65535
    ```

2. Add a sample route if needed:

    ```
    curl http://localhost:8001/routes \
      -d name=acme-example \
      -d paths[]=/.well-known/acme-challenge \
      -d service.name=acme-example
    ```

3. Enable the plugin:

    ```sh
    curl http://localhost:8001/plugins \
      -d name=acme \
      -d config.account_email=yourname@yourdomain.com \
      -d config.tos_accepted=true \
      -d config.domains[]=my.secret.domains.com
    ```

Setting `tos_accepted` to *true* implies that you have read and accepted
[terms of service](https://letsencrypt.org/repository/).

**This plugin can only be configured as a global plugin.** The plugin terminates
`/.well-known/acme-challenge/` path for matching domains. To create certificates
and terminate challenges only for certain domains, refer to the
[Parameters](/hub/kong-inc/acme/configuration/) section.

### Trigger certificate creation

Assume Kong proxy is accessible via http://mydomain.com and https://mydomain.com.

1. Run a sanity test on your Kong setup before creating any certificate:

    ```sh
    curl http://localhost:8001/acme \
    -d host=mydomain.com \
    -d test_http_challenge_flow=true
    ```

1. Trigger certificate creation:

    You can trigger asynchronous creation from proxy requests.

    The following request returns Kong's default certificate: 

    ```sh
    curl https://mydomain.com -k
    ```
    Wait up to 1 minute for the background process to finish.

    Or, create it synchronously from the Admin API:

    ```sh
    curl http://localhost:8001/acme -d host=mydomain.com
    ```

    You can also use this endpoint to force renew a certificate.

1. Now, the following request gives you a valid Let's Encrypt certificate:

    ```sh
    curl https://mydomain.com
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

* [Local testing and development guide](/hub/kong-inc/acme/how-to/local-testing-development/)
* Monitoring and debugging: The ACME plugin exposes monitoring and debugging endpoints 
through the {{site.base_gateway}} Admin API. See the 
[ACME API reference](/hub/kong-inc/acme/api/) for more information.
* [ACME plugin configuration reference](/hub/kong-inc/acme/configuration/) and 
[basic configuration examples](/hub/kong-inc/acme/how-to/basic-example/)

