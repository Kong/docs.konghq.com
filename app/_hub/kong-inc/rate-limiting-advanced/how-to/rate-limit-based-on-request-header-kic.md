---
nav_title: Set rate limit for a request header when using Kong Ingress Controller 
title: Set rate limit for a request header when using Kong Ingress Controller
---

Kong can match routes based on the request headers and then apply the Rate Limiting Advanced plugin on the route that has the header configured.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

{% include /md/kic/test-service-echo.md kong_version=page.kong_version skip_host=true %}

## Set up rate limiting

1. Create an instance of the rate-limiting plugin.

    ```bash
    echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: rate-limit
      annotations:
        kubernetes.io/ingress.class: kong
    config:
      minute: 5
      policy: local
    plugin: rate-limiting
    " | kubectl apply -f -
    ```

    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/rate-limit created
    ```
    
1. Associate the plugin with the Service.

    ```bash
    kubectl annotate service echo konghq.com/plugins=rate-limit
    ```

    The results should look like this:
    ```text
    service/echo annotated
    ```
    
1. Send requests through this Service to rate limiting response headers.

    ```bash
    curl -si $PROXY_IP/echo | grep RateLimit
    ```

    The results should look like this:
    ```text
    RateLimit-Limit: 5
    X-RateLimit-Remaining-Minute: 4
    X-RateLimit-Limit-Minute: 5
    RateLimit-Reset: 60
    RateLimit-Remaining: 4
    ```
    
## Set up Ingress routes

   Setup three Ingress routes named `echo`, `echo-no-rl`, and `echo-copy`.

1. Setup a route named `echo`.

   {% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version hostname='kong.example' path=path name=name service=service indent=true skip_host=include.skip_host route_type=route_type no_results=true %}

1. Setup a route named `echo-no-rl`.

   {% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version hostname='kong.example' path=path name='echo-no-rl' service=service indent=true skip_host=include.skip_host route_type=route_type no_results=true %}

1. Setup a route named `echo-copy`.

   {% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version hostname='kong.example' path=path name='echo-copy' service=service indent=true skip_host=include.skip_host route_type=route_type no_results=true %}

1. Then create `KongIngresses` that differentiate the routes based on headers and patch to associate these KongIngress resources with the Ingress resources using the `konghq.com/override`` annotation.

    ```bash
    kubectl patch ingress echo-copy -p '{"metadata":{"annotations":{"konghq.com/override":"header-bravo"}}}'
    kubectl patch ingress echo -p '{"metadata":{"annotations":{"konghq.com/override":"header-alpha"}}}'   
    ```

## Test the rate limit based on the request header

1. Send a plain request
   ```bash
   curl -i --resolve kong.example:80:127.0.0.1 http://kong.example/echo 
   ```
   The results should look like this:
   ```txt
   HTTP/1.1 200 OK
   Content-Type: text/plain; charset=utf-8
   Content-Length: 136
   Connection: keep-alive
   X-RateLimit-Remaining-Minute: 4
   X-RateLimit-Limit-Minute: 5
   RateLimit-Remaining: 4
   RateLimit-Reset: 6
   RateLimit-Limit: 5
   Date: Tue, 28 Nov 2023 09:37:54 GMT
   X-Kong-Upstream-Latency: 1
   X-Kong-Proxy-Latency: 1
   Via: kong/3.4.0

   Welcome, you are connected to node orbstack.
   Running on Pod echo-965f7cf84-6xwrw.
   In namespace default.
   With IP address 192.168.194.7.
   ```

1. Send a request with headers, but dont apply rate limit.
   ```bash
   curl -i --resolve kong.example:80:127.0.0.1 http://kong.example/echo -H "x-split: bravo" -H "x-legacy: enabled"
   ```
   The results should look like this:
   ```txt
   HTTP/1.1 200 OK
   Content-Type: text/plain; charset=utf-8
   Content-Length: 136
   Connection: keep-alive
   X-RateLimit-Remaining-Minute: 4
   X-RateLimit-Limit-Minute: 5
   RateLimit-Remaining: 4
   RateLimit-Reset: 51
   RateLimit-Limit: 5
   Date: Tue, 28 Nov 2023 09:38:09 GMT
   X-Kong-Upstream-Latency: 0
   X-Kong-Proxy-Latency: 1
   Via: kong/3.4.0
   
   Welcome, you are connected to node orbstack.
   Running on Pod echo-965f7cf84-6xwrw.
   In namespace default.
   With IP address 192.168.194.7.
   ```
1. Send a request with headers and apply rate limit.
   ```bash
   curl -i --resolve kong.example:80:127.0.0.1 http://kong.example/echo -H "x-split: alpha"
   ```
   The results should look like this:
   ```txt
   HTTP/1.1 200 OK
   Content-Type: text/plain; charset=utf-8
   Content-Length: 136
   Connection: keep-alive
   X-RateLimit-Remaining-Minute: 3
   X-RateLimit-Limit-Minute: 5
   RateLimit-Remaining: 3
   RateLimit-Reset: 26
   RateLimit-Limit: 5
   Date: Tue, 28 Nov 2023 09:38:34 GMT
   X-Kong-Upstream-Latency: 0
   X-Kong-Proxy-Latency: 1
   Via: kong/3.4.0

   Welcome, you are connected to node orbstack.
   Running on Pod echo-965f7cf84-6xwrw.
   In namespace default.
   With IP address 192.168.194.7.
   ```