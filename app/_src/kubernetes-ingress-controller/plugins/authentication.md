---
title: Authentication
type: how-to
purpose: |
  List available authentication plugins. Explain how consumers/credentials work. Mention how to apply multiple auth plugins with anonymous consumers.
---

Learn to configure multiple authentication options for consumers using the {{site.kic_product_name}}.

The default behavior for Kong authentication plugins is to require credentials
for all requests even if a request has been authenticated through another plugin. Configure an anonymous consumer on your authentication plugins to set clients authentication options.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

{% include /md/kic/test-service-httpbin.md %}

{% include /md/kic/http-test-routing-resource.md kong_version=page.kong_version path='/test' name='httpbin' service='httpbin' port='80' skip_host=true %}

## Create Consumers and secrets

Create two consumers that use different authentication methods:

* `consumer-1` uses `basic-auth`
* `consumer-2` uses `key-auth`

1. Create a secret to add `basic-auth` credential for `consumer-1`.

    ```bash
    kubectl create secret generic consumer-1-basic-auth  \
      --from-literal=kongCredType=basic-auth  \
      --from-literal=username=consumer-1 \
      --from-literal=password=consumer-1-password
    ```
    The results should look like this:
    ```text
    secret/consumer-1-basic-auth created
    ```

1. Create a consumer named `consumer-1`.
    {% include /md/kic/consumer.md kong_version=page.kong_version name='consumer-1' credName='consumer-1-basic-auth' %}

1. Create a secret to add `key-auth` credential for `consumer-2`. 
    {% include /md/kic/key-auth.md kong_version=page.kong_version credName='consumer-2-key-auth' key='consumer-2-password' %}

1. Create a consumer named `consumer-2`.
    {% include /md/kic/consumer.md kong_version=page.kong_version name='consumer-2' credName='consumer-2-key-auth' %}

## Secure the Ingress

1. Create two plugins.

    * Create a plugin named `httpbin-basic-auth`.

    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: httpbin-basic-auth
    config:
      anonymous: anonymous
      hide_credentials: true
    plugin: basic-auth
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/httpbin-basic-auth created
    ```
    * Create a plugin named `httpbin-key-auth`.

    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: httpbin-key-auth
    config:
      key_names:
        - apikey
      anonymous: anonymous
      hide_credentials: true
    plugin: key-auth
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/httpbin-key-auth created
    ```

1. Associate the plugins with the route that you created.

{% include /md/kic/annotate-plugin.md name='httpbin' plugins="httpbin-basic-auth, httpbin-key-auth" skip_header=true indent=true %}

## Anonymous Consumers

Your endpoints are now secure, but neither consumer can access the endpoint when providing valid credentials. This is because each plugin will verify the consumer using it's own authentication method.

To allow multiple authentication methods, create an anonymous consumer which is the default user if no valid credentials are provided:

1. Create a consumer named `anonymous`.
    {% include /md/kic/consumer.md kong_version=page.kong_version name='anonymous' %}

    All requests to the API will now succeed as the anonymous consumer is being used as a default.

    To secure the API once again, add a request termination plugin to the anonymous consumer that returns `HTTP 401`:

1. Create a `Request Termination` plugin.

    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: anonymous-request-termination
    config:
      message: "Authentication required"
      status_code: 401
    plugin: request-termination
    ' | kubectl apply -f -
    ```

    The results should look like this:

    ```text
    kongplugin.configuration.konghq.com/anonymous-request-termination created
    ```

1. Associate the `Request Termination` plugin to the `anonymous` consumer.
    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1
    kind: KongConsumer
    metadata:
      annotations:
        konghq.com/plugins: anonymous-request-termination
        kubernetes.io/ingress.class: kong
      name: anonymous
    username: anonymous
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/anonymous configured
    ```
 
## Test the configuration
Any requests with missing or invalid credentials are rejected, whereas authorized requests using either of the authentication methods are allowed.

1. Send a request with invalid credentials.
    ```bash
    curl -i $PROXY_IP/test/status/200 -H apikey:invalid
    ```

    The results should look like this:
    ```text
    HTTP/1.1 401 Unauthorized
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    WWW-Authenticate: Key realm="kong"
    Content-Length: 37
    X-Kong-Response-Latency: 3
    Server: kong/3.3.1

    {"message":"Authentication required"}%
    ```

1. Send a request without any credentials.
    ```bash
    curl -i $PROXY_IP/test/status/200
    ```
    The results should look like this:
    ```text
    HTTP/1.1 401 Unauthorized
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    WWW-Authenticate: Key realm="kong"
    Content-Length: 37
    X-Kong-Response-Latency: 1
    Server: kong/3.3.1

    {"message":"Authentication required"}%
    ```

1. Send a request using the `basic-auth` authentication method
    ```bash
    curl -i $PROXY_IP/test/status/200 -u consumer-1:consumer-1-password
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 0
    Connection: keep-alive
    WWW-Authenticate: Key realm="kong"
    Server: gunicorn/19.9.0
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Credentials: true
    X-Kong-Upstream-Latency: 1309
    X-Kong-Proxy-Latency: 3
    Via: kong/3.3.1
```

1. Send a request using the `key-auth` authentication method
    ```bash
    curl -i $PROXY_IP/test/status/200 -H apikey:consumer-2-password
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 0
    Connection: keep-alive
    Server: gunicorn/19.9.0
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Credentials: true
    X-Kong-Upstream-Latency: 1227
    X-Kong-Proxy-Latency: 4
    Via: kong/3.3.1
    ```
