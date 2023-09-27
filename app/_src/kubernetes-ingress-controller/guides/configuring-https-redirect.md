---
title: Configuring https redirect
---

Learn to configure the {{site.kic_product_name}} to redirect HTTP request to HTTPS so that all communication from the external world to your APIs and microservices is encrypted.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=true%}

## Setup a Sample service

1. Create an [httpbin](https://httpbin.org) service in the cluster and proxy it.

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{site.data.kong_latest_KIC.version}}/deploy/manifests/httpbin.yaml
    ```
    The results should look like this:

    ```text
    service/httpbin created
    deployment.apps/httpbin created
    ```
1.  Create an Ingress rule to proxy the `httpbin` service.

    ```bash
    $ echo '
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
            pathType: ImplementationSpecific
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
1.  Test the Ingress rule.

    ```bash
    $ curl -i $PROXY_IP/test/status/200
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 0
    Connection: keep-alive
    Server: gunicorn/19.9.0
    Date: Wed, 27 Sep 2023 10:37:46 GMT
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Credentials: true
    X-Kong-Upstream-Latency: 3
    X-Kong-Proxy-Latency: 1
    Via: kong/3.3.1
    ```

## Setup HTTPS redirect

To instruct Kong to redirect all HTTP requests matching this Ingress rule to
HTTPS, update its annotations.

1. Limit the protocols of the Ingress rule to HTTPS only and issue a 308 redirect.

    ```bash
    $ kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/protocols":"https","konghq.com/https-redirect-status-code":"308"}}}'
    ```
    The results should look like this:
    ```text
    ingress.networking.k8s.io/demo patched
    ```
1. Make a plain-text HTTP request to Kong and a redirect is issued.

    ```bash
    $ curl $PROXY_IP/test/headers -I
    ```
    The results should look like this:
    ```text
    HTTP/1.1 308 Permanent Redirect
    Date: Tue, 06 Aug 2019 18:04:38 GMT
    Content-Type: text/html
    Content-Length: 167
    Connection: keep-alive
    Location: https://192.0.2.0/test/headers
    Server: kong/1.2.1
    ```

The `Location` header contains the URL you need to use for an HTTPS
request. This URL varies depending on your installation method. You can also get the IP address of the load balancer for Kong and send a HTTPS request to test.


## Test the configuration

1. Send a request to the `Location` URL.
    ```bash
    $ curl -k https://192.0.2.0/test/headers
    ```
    The results should look like this:
    ```text
    {
      "headers": {
        "Accept": "*/*",
        "Connection": "keep-alive",
        "Host": "192.0.2.0",
        "User-Agent": "curl/8.1.2",
        "X-Forwarded-Host": "192.0.2.0"
      }
    }
    ```

Kong correctly serves the request only on HTTPS protocol and redirects the user if plaint-text HTTP protocol is used. The `-k` flag in cURL skips certificate validation as the certificate served by Kong is a self-signed one. If you are serving this traffic through a domain that you control and have configured TLS properties for it, then the flag won't
be necessary.

If you have a domain that you control but don't have TLS/SSL certificates
for it, see [Using cert-manager with Kong](/kubernetes-ingress-controller/{{page.kong_version}}/guides/cert-manager) guide which can get TLS certificates setup for you automatically. And it's free, thanks to Let's Encrypt!
