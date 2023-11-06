---
title: Health Checks
type: how-to
purpose: |
  How to enable passive and active health checks for upstream services
---

Setup active and passive health checking using the {{site.kic_product_name}}. This configuration allows
Kong to automatically short-circuit requests to specific Pods that are mis-behaving in your Kubernetes Cluster.

When you setup a passive health check for a service that runs in a cluster and if the Pod that runs the service reports an error, Kong returns a 503, indicating that the service is unavailable. Kong does not proxy anymore requests.
There are a few options that you can consider:

- Delete the current Pod; Kong then sends proxy requests to the new Pod that comes in its place.
- Scale the deployment; Kong then sends proxy requests to the new Pods and leave the short-circuited Pod out of the loop.
- Manually change the Pod health status in Kong using Kong's [Admin API](/gateway/latest/admin-api/#set-target-as-healthy).

These options highlight the fact that once a circuit is opened because of errors, there is no way for Kong to close the circuit again. Manual intervention is necessary so that a Pod can again handle requests.
You can use active health-check, where each instance of Kong actively probes Pods to check if they are healthy.


{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

{% include /md/kic/test-service-httpbin.md %}

## Add routing configuration

1. Expose the service outside the Kubernetes cluster.

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Gateway API %}
```bash
echo '
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: demo
  annotations:
    konghq.com/strip-path: "true"
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /test
    backendRefs:
    - name: httpbin
      kind: Service
      port: 80
' | kubectl apply -f -
```
{% endnavtab %}

{% navtab Ingress %}
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
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}
    
    The results should look like this:
    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/demo created
```
{% endnavtab %}
{% navtab Ingress %}
```text
ingress.networking.k8s.io/demo created
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}
 
1. Test these endpoints.

    ```bash
    curl -i $PROXY_IP/test/status/200
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
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 1
    Via: kong/3.4.2
    ```

   Observe the headers and you can see that Kong has proxied the request correctly.

## Setup passive health checking

1.  All health checks are done at Service-level and not Ingress-level. To configure Kong to short-circuit requests to a Pod if it throws 3 consecutive errors, add a KongUpstreamPolicy resource.

    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1beta1
    kind: KongUpstreamPolicy
    metadata:
        name: demo-health-checking
    spec:
      healthchecks:
        passive:
          healthy:
            successes: 3
          unhealthy:
            httpFailures: 3
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongupstreampolicy.configuration.konghq.com/demo-health-checking created
    ```      
1. Associate the KongUpstreamPolicy resource with `httpbin` service.

    ```bash
    kubectl patch svc httpbin -p '{"metadata":{"annotations":{"konghq.com/upstream-policy":"demo-health-checking"}}}'
    ```
    The results should look like this:
    ```text
    service/httpbin patched
    ```      
1. Test the Ingress rule by sending 2 requests that represent a failure from upstream and then send a request for 200. The requests with `/status/500` simulate a failure from upstream.
    Send two requests with `status/500`.
    ```bash
    $ curl -i $PROXY_IP/test/status/500
    $ curl -i $PROXY_IP/test/status/500
    ```
    The results should look like this:
    ```text
    HTTP/1.1 500 INTERNAL SERVER ERROR
    Content-Type: text/html; charset=utf-8
    Content-Length: 0
    Connection: keep-alive
    Server: gunicorn/19.9.0
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Credentials: true
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 0
    Via: kong/3.4.2
    ```
    Send the third request with `status/200`
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
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Credentials: true
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 0
    Via: kong/3.4.2
    ```            
    Kong has not short-circuited because there were only two failures.

1. Send 3 requests to open the circuit, and then send a normal request.
    Send two requests with `status/500`.
    ```bash
    $ curl -i $PROXY_IP/test/status/500
    $ curl -i $PROXY_IP/test/status/500
    $ curl -i $PROXY_IP/test/status/500
    ```
    The results should look like this:
    ```text
    HTTP/1.1 500 INTERNAL SERVER ERROR
    Content-Type: text/html; charset=utf-8
    Content-Length: 0
    Connection: keep-alive
    Server: gunicorn/19.9.0
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Credentials: true
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 0
    Via: kong/3.4.2
    ```          
    Send the fourth request with `status/200`
    ```bash
    curl -i $PROXY_IP/test/status/200
    ```
    The results should look like this:
    ```text
    HTTP/1.1 503 Service Temporarily Unavailable
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Content-Length: 62
    X-Kong-Response-Latency: 0
    Server: kong/3.4.2
    
    {
      "message":"failure to get a peer from the ring-balancer"
    }%                  
    ```            

    Kong returns a 503, indicating that the service is unavailable. Because there is only one Pod of `httpbin` service running in the cluster, and that is throwing errors, Kong does not proxy anymore requests. To get around this, you can use active health-check, where each instance of Kong actively probes Pods to check if they are healthy.

## Setup active health checking
1.  Update the KongUpstreamPolicy resource to use active health-checks.
    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1beta1
    kind: KongUpstreamPolicy
    metadata:
        name: demo-health-checking
    spec:
      healthchecks:
        active:
          healthy:
            interval: 5
            successes: 3
          httpPath: /status/200
          type: http
          unhealthy:
            httpFailures: 1
            interval: 5
        passive:
          healthy:
            successes: 3
          unhealthy:
            httpFailures: 3
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongupstreampolicy.configuration.konghq.com/demo-health-checking configured
    ```      
    
    This configures Kong to actively probe `/status/200` every 5 seconds. If a Pod is unhealthy from Kong's perspective, 3 successful probes changes the status of the Pod to healthy and Kong again starts to forward requests to that Pod. Wait 15 seconds for the pod to be marked as healthy before continuing.

1. Test the Ingress rule.
    ```bash
    curl -i $PROXY_IP/test/status/200
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
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 1
    Via: kong/3.4.2
    ```            
1.  Trip the circuit again by sending three requests that returns the status 500 from httpbin.
    ```bash
    $ curl -i $PROXY_IP/test/status/500
    $ curl -i $PROXY_IP/test/status/500
    $ curl -i $PROXY_IP/test/status/500
    ```

    When you send the requests, it fails for about 15 seconds, the duration for active health checks to re-classify the httpbin Pod as healthy again.

    ```bash
    $ curl -i $PROXY_IP/test/status/200
    ```
    The results should look like this:
    ```text
    HTTP/1.1 503 Service Temporarily Unavailable
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Content-Length: 62
    X-Kong-Response-Latency: 0
    Server: kong/3.4.2
    
    {
      "message":"failure to get a peer from the ring-balancer"
    }%                  
    ```          
1.  Send the requests after 15 seconds or so.

    ```bash
    curl -i $PROXY_IP/test/status/200
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
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 1
    Via: kong/3.4.2
    ```


Read more about health-checks and circuit breaker in Kong's
[documentation](/gateway/latest/reference/health-checks-circuit-breakers).

