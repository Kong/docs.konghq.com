---
nav_title: Local testing and development
title: Local testing and development
---

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

### Configure and test the plugin

1. Configure a service:

    ```bash
    curl http://localhost:8001/services \
    -d name=acme-test \
    -d url=http://httpbin.org
    ```

1. Configure a route:
    ```
    curl http://localhost:8001/routes \
    -d service.name=acme-test \
    -d hosts=$NGROK_HOST
    ```

1. Enable the plugin:

    ```bash
    curl localhost:8001/plugins \
    -d name=acme \
    -d config.account_email=test@test.com \
    -d config.tos_accepted=true \
    -d config.domains[]=$NGROK_HOST
    ```

1. Trigger certificate creation:

    ```bash
    curl https://$NGROK_HOST:8443 --resolve $NGROK_HOST:8443:127.0.0.1 -vk
    # Wait for several seconds
    ```

1. Check the new certificate:

    ```bash
    echo q |openssl s_client -connect localhost -port 8443 -servername $NGROK_HOST 2>/dev/null |openssl x509 -text -noout
    ```
