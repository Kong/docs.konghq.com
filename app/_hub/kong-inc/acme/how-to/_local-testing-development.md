---
nav_title: Local testing and development
title: Local testing and development
---

## Run ngrok

[ngrok](https://ngrok.com) exposes a local URL to the internet. [Download ngrok](https://ngrok.com/download) and install.

{:.note}
> `ngrok` is only needed for local testing or development, it's **not** a requirement for the plugin itself.

Run ngrok:

```bash
./ngrok http localhost:8000
```

The output includes your generated hostname:
```bash
Forwarding    http://example-host-12345.ngrok.io -> http://localhost:8000
Forwarding    https://example-host-12345.ngrok.io -> http://localhost:8000
```

Substitute `example-host-12345.ngrok.io` with the host shown in your ngrok output 
and export the hostname to an environment variable:

```bash
export NGROK_HOST=example-host-12345.ngrok.io
```

Leave the process running.

## Configure the plugin

1. Configure a service:

    ```bash
    curl http://localhost:8001/services \
      --data "name=acme-test" \
      --data "url=http://httpbin.org"
    ```

1. Configure a route:
    ```bash
    curl http://localhost:8001/routes \
      --data "service.name=acme-test" \
      --data "hosts=$NGROK_HOST"
    ```

1. Enable the plugin:

    ```bash
    curl localhost:8001/plugins \
      --data "name=acme" \
      --data "config.account_email=test@test.com" \
      --data "config.tos_accepted=true" \
      --data "config.domains[]=$NGROK_HOST" \
      --data "config.storage=kong"
    ```

    This example uses `kong` storage for demo purposes, which stores the certificate in the Kong database.
    `kong` storage is not supported in DB-less mode or {{site.konnect_short_name}}, use one of the other [storage options](/hub/kong-inc/acme/#storage-options) instead.

## Validate

1. Trigger certificate creation:

    ```bash
    curl https://$NGROK_HOST:8443 --resolve $NGROK_HOST:8443:127.0.0.1 -vk
    ```
    This might take a few seconds.

1. Check the new certificate:

    ```bash
    echo q |openssl s_client -connect localhost -port 8443 -servername $NGROK_HOST 2>/dev/null |openssl x509 -text -noout
    ```
