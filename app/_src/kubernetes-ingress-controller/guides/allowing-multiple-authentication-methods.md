---
title: Allowing Multiple Authentication Methods
content-type: how-to
---
Learn to configure multiple authentication options for consumers using the {{site.kic_product_name}}.
The default behavior for Kong authentication plugins is to require credentials
for all requests even if a request has been authenticated through another plugin. Configure an anonymous consumer on your authentication plugins to set clients authentication options.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=true %}

## Create a Kubernetes service

Create a Kubernetes service setup an [httpbin](https://httpbin.org)
service in the cluster and proxy it.

```bash
$ kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{site.data.kong_latest_KIC.version}}/deploy/manifests/httpbin.yaml
```
The results should look like this:

```text
service/httpbin created
deployment.apps/httpbin created
```

## Setup Ingress rules

1. Expose the service outside the Kubernetes cluster by defining Ingress rules.

    ```bash
    echo '
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: demo
      annotations:
        konghq.com/strip-path: "true"
    spec:
      ingressClassName: kong
      rules:
      - http:
          paths:
          - path: /test
            pathType: Prefix
            backend:
              service:
                name: httpbin
                port:
                  number: 80
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    ingress.networking.k8s.io/demo created
    ```

## Create Consumers and secrets

1. Create a consumer named `consumer-1`.
   {% include_cached /md/kic/consumer.md kong_version=page.kong_version name='consumer-1' %}

1. Create a secret to add `basic-auth` credential for `consumer-1`.
   To add a `basic-auth` credential to `consumer-1`, you need to create a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) resource with an API-key, username, and password.

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
1. Create a consumer named `consumer-2`.
   {% include_cached /md/kic/consumer.md kong_version=page.kong_version name='consumer-2' %}

1. Create a secret to add `key-auth` credential for `consumer-2`. 
{% include_cached /md/kic/key-auth.md kong_version=page.kong_version credName='consumer-2-key-auth' key='consumer-2-password' %}


## Associate plugins with the Ingress rules

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

1. Associate the plugins with the Ingress rule that you created.

    ```bash
    kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"httpbin-basic-auth, httpbin-key-auth"}}}'
    ```
    The results should look like this:
    ```text
    ingress.networking.k8s.io/demo patched
    ``` 
1. Associate the keys with the consumer that you created. You don't have to create the  KongConsumer resource again, you only need to update it to include the `credentials` array.

    Associate `consumer-1` with `consumer-1-basic-auth`.
{% include_cached /md/kic/consumer.md kong_version=page.kong_version name='consumer-1' credName='consumer-1-basic-auth' %}

    Associate `consumer-2` with `consumer-2-key-auth`.
{% include_cached /md/kic/consumer.md kong_version=page.kong_version name='consumer-2' credName='consumer-2-key-auth' %}

    At this point none of the requests are allowed. Even requests with valid credentials are not allowed.

1. Test requests.

    ```bash
    curl -i $PROXY_IP/test/status/200
    ```
    The results should look like this:
    ```text
    HTTP/1.1 500 Internal Server Error
    Date: Wed, 13 Sep 2023 09:28:54 GMT
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    WWW-Authenticate: Key realm="kong"
    Content-Length: 46
    X-Kong-Response-Latency: 1
    Server: kong/3.3.1
    
    {
      "message":"An unexpected error occurred"
    }%
    ```
1. Test valid credentials requests.
    ```bash
    curl -i $PROXY_IP/test/status/200 -H "apikey=consumer-2-password"
    ```
   The results should look like this:
    ```text
    HTTP/1.1 500 Internal Server Error
    Date: Wed, 13 Sep 2023 09:28:54 GMT
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    WWW-Authenticate: Key realm="kong"
    Content-Length: 46
    X-Kong-Response-Latency: 1
    Server: kong/3.3.1
    
    {
      "message":"An unexpected error occurred"
    }% 
    ```
1. Create a consumer named `anonymous`.
   {% include_cached /md/kic/consumer.md kong_version=page.kong_version name='anonymous' %}

1. Test requests. All requests including the requests with invalid authentication are allowed.

    ```bash
    curl -i $PROXY_IP/test/status/200
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
    X-Kong-Upstream-Latency: 2488
    X-Kong-Proxy-Latency: 4
    Via: kong/3.3.1
    ```
1. Test invalid credentials requests.
    ```bash
    curl -i $PROXY_IP/test/status/200 -H "apikey=invalid"
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
    X-Kong-Upstream-Latency: 1031
    X-Kong-Proxy-Latency: 1
    Via: kong/3.3.1
    ```   
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
    
## Test the configurations
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

1. Send a request without any authentication.
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
