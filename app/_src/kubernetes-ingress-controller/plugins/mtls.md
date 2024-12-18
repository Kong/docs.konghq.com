---
title: mTLS
type: how-to
purpose: |
  How to configure the mTLS plugin
---
Configure the {{site.kic_product_name}} to verify client certificates using CA certificates and
[mtls-auth](/hub/kong-inc/mtls-auth/) plugin for HTTPS requests.

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false enterprise=true %}

1. Generate self-signed CA certificates using OpenSSL:

    ```bash
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes \
    -subj "/C=US/ST=California/L=San Francisco/O=Kong/OU=Org/CN=www.example.com"
    ```

1. Add the generated certificates to Kong.

    {% include /md/kic/ca-certificates-note.md %}

    ```bash
    $ kubectl create secret generic my-ca-cert --from-literal=id=cce8c384-721f-4f58-85dd-50834e3e733a --from-file=cert=./cert.pem
    $ kubectl label secret my-ca-cert 'konghq.com/ca-cert=true'
    $ kubectl annotate secret my-ca-cert 'kubernetes.io/ingress.class=kong'
    ```

    The results should look like this:

    ```text
    secret/my-ca-cert created
    secret/my-ca-cert labeled
    secret/my-ca-cert annotated
    ```

1. Configure `mtls-auth` KongPlugin resource which references the CA certificate. Make sure that the ID matches the ID provided in your `kubectl create secret` command:

    ```bash
    $ echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: mtls-auth
    config:
      ca_certificates:
      - cce8c384-721f-4f58-85dd-50834e3e733a
      skip_consumer_lookup: true
      revocation_check_mode: SKIP
    plugin: mtls-auth
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/mtls-auth created
    ```

{% include /md/kic/test-service-echo.md release=page.release %}

{% include /md/kic/http-test-routing.md release=page.release path='/echo' name='echo' skip_host=true %}

{% include /md/kic/annotate-plugin.md name='echo' plugins='mtls-auth' %}

## Test the configuration

1. Send a request to check Kong prompts you for client certificate.

    ```
    $ curl -i -k https://$PROXY_IP/echo
    ```
    The results should look like this:
    ```text
    HTTP/2 401
    content-type: application/json; charset=utf-8
    content-length: 50
    x-kong-response-latency: 0
    server: kong/2.0.4.0-enterprise-k8s

    {"message":"No required TLS certificate was sent"}
    ```

    As you can see, Kong is restricting the request because it doesn't have the necessary authentication information.

   Two things to note here:
   - `-k` is used because Kong is set up to serve a self-signed certificate by default. For full mutual authentication in production use cases, you must configure Kong to serve a certificate that is signed by a trusted CA.
   - For some deployments `$PROXY_IP` might contain a port that points to `http` port of Kong. In others, it might happen that it contains a DNS name instead of an IP address. If needed, update the command to send an `https` request to the `https` port of Kong or the load balancer in front of it.

1. Use the key and certificate to authenticate against Kong and use the service:

    ```bash
    $ curl --key key.pem --cert cert.pem  https://$PROXY_IP/echo -k -I
    ```
    The results should look like this:
    ```text
    HTTP/2 200
    content-type: text/plain; charset=UTF-8
    server: echoserver
    x-kong-upstream-latency: 1
    x-kong-proxy-latency: 1
    via: kong/2.0.4.0-enterprise-k8s
    ```
