---
title: Rate Limiting
book: kic-get-started
chapter: 3
type: tutorial
purpose: |
  How to configure rate limiting with Redis
---

Rate limiting is used to control the rate of requests sent to an upstream service. It can be used to prevent DoS attacks, limit web scraping, and other forms of overuse. Without rate limiting, clients have unlimited access to your upstream services, which may negatively impact availability.

{{site.base_gateway}} imposes rate limits on clients through the [Rate Limiting plugin](/hub/kong-inc/rate-limiting/).  When rate limiting is enabled, clients are restricted in the number of requests that can be made in a configurable period of time.  The plugin supports identifying clients as consumers based on authentication or by the client IP address of the requests.

## Create a rate-limiting KongPlugin

Configuring plugins with {{ site.kic_product_name }} is different compared to how you'd do it with {{ kic.base_gateway }}. Rather than attaching a configuration directly to a service or route, you create a `KongPlugin` definition and then annotate your Kubernetes resource with the `konghq.com/plugins` annotation.

{:.note}
> This tutorial uses the [Rate Limiting](/hub/kong-inc/rate-limiting/) <span class="badge free"></span> plugin. The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) <span class="badge enterprise"></span> plugin is also available. The advanced version provides additional features such as support for the sliding window algorithm and advanced Redis support for greater performance.

```yaml
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit-5-min
  annotations:
    kubernetes.io/ingress.class: kong
config:
  minute: 5
  policy: local
plugin: rate-limiting
" | kubectl apply -f -
```

## Associate the plugin with a service or route

Plugins can be linked to a service or a route. Adding a rate limit plugin to a service shares the limit across all routes contained within that service. 


```bash
kubectl annotate service echo konghq.com/plugins=rate-limit-5-min
```

Alternatively you can add the rate limit plugin to a route. Adding a rate limit plugin to a route sets a rate limit per-route.

{% navtabs api %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute echo konghq.com/plugins=rate-limit-5-min
```
{% endnavtab %}
{% navtab Ingress %}
```bash
kubectl annotate ingress echo konghq.com/plugins=rate-limit-5-min
```
{% endnavtab %}
{% endnavtabs %}

## Test the rate-limiting plugin

To test the rate-limiting plugin, rapidly send six requests to `$PROXY_IP/echo`:

```bash
for i in `seq 6`; do curl -sv $PROXY_IP/echo 2>&1 | grep "< HTTP"; done
```

The final request receives a `HTTP 429` error.

```text
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 429 Too Many Requests
```

This shows that the rate limiting plugin is preventing the request from reaching the upstream service.

## Further reading

For more information about rate limiting, see [scale to multiple pods](/kubernetes-ingress-controller/{{ page.release }}/plugins/rate-limiting/#scale-to-multiple-pods) in the Rate Limiting plugin documentation.