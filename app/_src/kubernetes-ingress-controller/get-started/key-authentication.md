---
title: Key Authentication
book: kic-get-started
chapter: 5
type: tutorial
purpose: |
  Show how to enable Key Authentication with KIC, including creating a consumer and a credential
---


Authentication is the process of verifying that a requester has permissions to access a resource. 
API gateway authentication authenticates the flow of data to and from your upstream services. 

{{site.base_gateway}} has a library of plugins that support 
the most widely used [methods of API gateway authentication](/hub/#authentication). 

Common authentication methods include:
* Key Authentication
* Basic Authentication
* OAuth 2.0 Authentication
* LDAP Authentication Advanced
* OpenID Connect

## Authentication benefits

With {{site.base_gateway}} controlling authentication, requests won't reach upstream services unless the client has successfully
authenticated. This means upstream services process pre-authorized requests, freeing them from the 
cost of authentication, which is a savings in compute time *and* development effort.

{{site.base_gateway}} has visibility into all authentication attempts and enables you to build 
monitoring and alerting capabilities which support service availability and compliance. 

For more information, see [What is API Gateway Authentication?](https://konghq.com/learning-center/api-gateway/api-gateway-authentication).

### Add authentication to the echo service

1. Create a new `key-auth` plugin.

    ```bash
    echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: key-auth
    plugin: key-auth
    config:
      key_names:
      - apikey
    " | kubectl apply -f -
    ```

1. Apply the `key-auth` plugin to the `echo` service in addition to the previous `rate-limit` plugin.

    ```bash
    kubectl annotate service echo konghq.com/plugins=rate-limit-5-min,key-auth --overwrite
    ```

1. Test that the API is secure by sending a request using `curl -i $PROXY_IP/echo`. Observe that a `HTTP 401` is returned with this message:

    ```text
    HTTP/1.1 401 Unauthorized
    Date: Wed, 11 Jan 2044 18:33:46 GMT
    Content-Type: application/json; charset=utf-8
    WWW-Authenticate: Key realm="kong"
    Content-Length: 45
    X-Kong-Response-Latency: 1
    Server: kong/{{ site.data.kong_latest_gateway.ce-version }}

    {
      "message":"No API key found in request"
    }
    ```

### Set up consumers and keys 

Key authentication in {{site.base_gateway}} works by using the consumer object. Keys are assigned to consumers, and client applications present the key within the requests they make.

Keys are stored as Kubernetes `Secrets` and consumers are managed with the `KongConsumer` CRD.

1. Create a new `Secret` where `kongCredType=key-auth`. 

    ```bash
    kubectl create secret generic alex-key-auth \
      --from-literal=kongCredType=key-auth \
      --from-literal=key=hello_world
    ```

1. Create a new consumer and attach the credential.

    ```bash
    echo "apiVersion: configuration.konghq.com/v1
    kind: KongConsumer
    metadata:
      name: alex
      annotations:
        kubernetes.io/ingress.class: kong
    username: alex
    credentials:
    - alex-key-auth
    " | kubectl apply -f -
    ```

1. Make a request to the API and provide your `apikey`:

    ```bash
    curl -H 'apikey: hello_world' $PROXY_IP/echo
    ```

    The results should look like this:

    ```
    Welcome, you are connected to node orbstack.
    Running on Pod echo-965f7cf84-mvf6g.
    In namespace default.
    With IP address 192.168.194.10.
    ```

## Next Steps

Congratulations! By making it this far you've deployed {{ site.kic_product_name }}, configured a service and route, added rate limiting, proxy caching and API authentication all using your normal Kubernetes workflow.

You can learn more about the available plugins (including Kubernetes configuration instructions) on the [Plugin Hub](/hub/). For more information about {{ site.kic_product_name }} and how it works, see the [architecture](/kubernetes-ingress-controller/{{ page.release }}/concepts/architecture/) page.