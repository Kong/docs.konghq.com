---
title: Getting started with the Kong Ingress Controller
content_type: tutorial
---

## Overview

Deploy an upstream HTTP application, create a configuration group, add a route, and add a plugin using 
{{site.base_gateway}} and {{site.kic_product_name}}.

{% include_cached /md/kic/installation.md release=page.release %}

{% include_cached /md/kic/test-service-echo.md release=page.release %}

{% include_cached /md/kic/class.md release=page.release %}

{% include_cached /md/kic/http-test-routing.md release=page.release %}

## Add TLS configuration

{% include_cached /md/kic/add-tls-conf.md hostname='kong.example' release=page.release %}

## Using plugins on Ingress / Gateway API Routes

1. Setup a KongPlugin resource.

    ```bash
    echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: request-id
    config:
      header_name: my-request-id
      echo_downstream: true
    plugin: correlation-id
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/request-id created
    ```
1. Update your route configuration to use the new plugin.

 {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```bash
kubectl annotate ingress echo konghq.com/plugins=request-id
```
{% endnavtab %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute echo konghq.com/plugins=request-id
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```text
ingress.networking.k8s.io/echo annotated
```
{% endnavtab %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/echo annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}


    Kong now applies your plugin configuration to all routes associated with this resource.

1.  To verify, send another request through the proxy.

    ```bash
    curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    Content-Type: text/plain; charset=UTF-8
    Transfer-Encoding: chunked
    Connection: keep-alive
    Date: Thu, 10 Nov 2022 22:33:14 GMT
    Server: echoserver
    my-request-id: ea87894d-7f97-4710-84ae-cbc608bb8107#2
    X-Kong-Upstream-Latency: 0
    X-Kong-Proxy-Latency: 0
    Via: kong/3.1.1
    
    Hostname: echo-fc6fd95b5-6lqnc

    Pod Information:
    	node name:	kind-control-plane
    	pod name:	echo-fc6fd95b5-6lqnc
    	pod namespace:	default
    	pod IP:	10.244.0.9
    ...
    Request Headers:
        ...
    	my-request-id=ea87894d-7f97-4710-84ae-cbc608bb8107#2
    ...
    ```
    Requests that match the `echo` Ingress or HTTPRoute now include a `my-request-id` header with a unique ID in both their request headers upstream and their response headers downstream.

## Using plugins on Services

Kong can also apply plugins to Services. This allows you execute the same
plugin configuration on all requests to that Service, without configuring the same plugin on multiple Ingresses.

1. Create a KongPlugin resource.

    ```bash
    echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: rl-by-ip
    config:
      minute: 5
      limit_by: ip
      policy: local
    plugin: rate-limiting
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/rl-by-ip created
    ```
1. Apply the `konghq.com/plugins` annotation to the Kubernetes Service that needs rate-limiting.

    ```bash
    kubectl annotate service echo konghq.com/plugins=rl-by-ip
    ```
    The results should look like this:
    ```text
    service/echo annotated
    ```
    Kong now enforces a rate limit to requests proxied to this Service.        
1. To verify, send a request.
    ```bash
    curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    Content-Type: text/plain; charset=UTF-8
    Transfer-Encoding: chunked
    Connection: keep-alive
    X-RateLimit-Remaining-Minute: 4
    RateLimit-Limit: 5
    RateLimit-Remaining: 4
    RateLimit-Reset: 13
    X-RateLimit-Limit-Minute: 5
    Date: Thu, 10 Nov 2022 22:47:47 GMT
    Server: echoserver
    my-request-id: ea87894d-7f97-4710-84ae-cbc608bb8107#3
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 1
    Via: kong/3.1.1

    Hostname: echo-fc6fd95b5-6lqnc
    Pod Information:
    	node name:	kind-control-plane
    	pod name:	echo-fc6fd95b5-6lqnc
    	pod namespace:	default
    	pod IP:	10.244.0.9
    ...
    ```

## Next steps

* To learn how to secure proxied routes, see the [ACL and JWT Plugins Guide](/kubernetes-ingress-controller/{{page.release}}/guides/configure-acl-plugin/).
* The [External Services Guide](/kubernetes-ingress-controller/{{page.release}}/guides/using-external-service/) explains how to proxy services outside of your Kubernetes cluster.
{% if_version gte:2.4.x -%}
* [Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. The {{site.kic_product_name}} supports Gateway API by default. To learn how to use Gateway API supported by the {{site.kic_product_name}}, see [Using Gateway API](/kubernetes-ingress-controller/{{page.release}}/guides/using-gateway-api/).
{% endif_version %}
