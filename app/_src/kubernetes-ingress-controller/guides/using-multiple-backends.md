---
title: Using multiple backend Services
content_type: tutorial
beta: true
---

## Overview

HTTPRoute supports adding multiple Services under its
[`BackendRefs`][gateway-api-backendref] field. When you add multiple Services,
requests through the HTTPRoute are distributed across the Services. This guide
walks through creating an HTTPRoute with multiple backend Services.

{% include /md/kic/installation.md %}

{% include /md/kic/class.md %}

## Deploy multiple Services

To do so, you can deploy a second echo Service so that you have
a second `BackendRef` to use for traffic splitting.

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-services.yaml
```
{% endnavtab %}
{% navtab Response %}
```text
service/echo created
deployment.apps/echo created
service/echo2 created
deployment.apps/echo2 created
```
{% endnavtab %}
{% endnavtabs %}

## Create a multi-Service HTTPRoute

Now that those two Services are deployed, you can now deploy an HTTPRoute that
sends traffic to both of them. By default, traffic is distributed evenly across
all Services:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo 'apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: "true"
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /echo
    backendRefs:
    - name: echo
      kind: Service
      port: 80
    - name: echo2
      kind: Service
      port: 80
' | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
httproute.gateway.networking.k8s.io/echo created
```
{% endnavtab %}
{% endnavtabs %}

Sending many requests through this route and tabulating the results will show
an even distribution of requests across the Services.

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -s 192.168.96.0/echo/hostname?iteration=[1-200] -w "\n" | sort | uniq -c
```
{% endnavtab %}
{% navtab Response %}
```text
100 echo2-7cb798f47-gv6hs
100 echo-658c5ff5ff-tv275
```
{% endnavtab %}
{% endnavtabs %}

## Add Service weights

The `weight` field overrides the default distribution of requests across
Services. Each Service instead receives `weight / sum(all Service weights)`
percent of the requests. Add weights to the Services in the HTTPRoute's
backend list:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch --type json httproute echo -p='[
    {
	    "op":"add",
		"path":"/spec/rules/0/backendRefs/0/weight",
		"value":200
    },
    {   "op":"add",
	    "path":"/spec/rules/0/backendRefs/1/weight",
		"value":100
    }
]'
```
{% endnavtab %}
{% navtab Response %}
```text
httproute.gateway.networking.k8s.io/echo patched
```
{% endnavtab %}
{% endnavtabs %}

Sending the same requests will now show roughly 1/3 of the requests going to
`echo2` and 2/3 going to `echo`:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -s 192.168.96.0/echo/hostname?iteration=[1-200] -w "\n" | sort | uniq -c
```
{% endnavtab %}
{% navtab Response %}
```text
 67 echo2-7cb798f47-gv6hs
133 echo-658c5ff5ff-tv275
```
{% endnavtab %}
{% endnavtabs %}
