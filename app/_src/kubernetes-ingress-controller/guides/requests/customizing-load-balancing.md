---
title: Customizing load-balancing behavior with KongUpstreamPolicy
---

In this guide, we will learn how to use KongUpstreamPolicy resource to control
proxy load-balancing behavior.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-service.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

## Set up Ingress

Let's expose the echo service outside the Kubernetes cluster
by defining an Ingress.

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /foo
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 80
" | kubectl apply -f -
```
{% endnavtab %}

{% navtab Response %}
```bash
ingress.extensions/demo created
```
{% endnavtab %}
{% endnavtabs %}

Let's test:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -i $PROXY_IP/foo
```
{% endnavtab %}

{% navtab Response %}
```bash
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: echoserver
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/3.1.1

Hostname: echo-d778ffcd8-n9bss

Pod Information:
  node name:	gke-harry-k8s-dev-default-pool-bb23a167-8pgh
  pod name:	echo-d778ffcd8-n9bss
  pod namespace:	default
  pod IP:	10.60.0.4

Server values:
  server_version=nginx: 1.12.2 - lua: 10010

Request Information:
  client_address=10.60.1.10
  method=GET
  real path=/foo
  query=
  request_version=1.1
  request_scheme=http
  request_uri=http://35.233.170.67:8080/foo
```
{% endnavtab %}
{% endnavtabs %}

## Use KongUpstreamPolicy with a Service resource

By default, Kong will round-robin requests between upstream replicas. If you
run `curl -s $PROXY_IP/foo | grep "pod name:"` repeatedly, you should see the
reported Pod name alternate between two values.

You can configure the Kong upstream associated with the Service to use a
different [load balancing strategy](/gateway/latest/how-kong-works/load-balancing/#balancing-algorithms),
such as consistently sending requests to the same upstream based on a header
value (please see the [KongUpstreamPolicy reference](/kubernetes-ingress-controller/{{page.kong_version}}/references/custom-resources/#kongupstreampolicy)
for the full list of supported algorithms and their configuration options).

To modify these behaviours, let's first create a KongUpstreamPolicy resource
defining the new behaviour:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo '
apiVersion: configuration.konghq.com/v1beta1
kind: KongUpstreamPolicy
metadata:
  name: sample-customization
spec:
  algorithm: consistent-hashing
  hashOn:
    header: x-lb
  hashOnFallback:
    input: ip
  ' | kubectl apply -f -
```
{% endnavtab %}

{% navtab Response %}
```bash
kongupstreampolicy.configuration.konghq.com/test created
```
{% endnavtab %}
{% endnavtabs %}

Now, let's associate this KongUpstreamPolicy resource with our Service resource
using the `konghq.com/upstream-policy` annotation.

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/upstream-policy":"sample-customization"}}}'
```
{% endnavtab %}

{% navtab Response %}
```bash
service/echo patched
```
{% endnavtab %}
{% endnavtabs %}

With consistent hashing and client IP fallback, sending repeated requests without any `x-lb` header now sends them to the
same Pod:

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..5}; do curl -s $PROXY_IP/foo | grep "pod name:"; done
```
{% endnavtab %}

{% navtab Response %}
```bash
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
```
{% endnavtab %}
{% endnavtabs %}

If you add the header, Kong hashes its value and distributes it to the
same replica when using the same value:

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..3}; do
  curl -s $PROXY_IP/foo -H "x-lb: foo" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: bar" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: baz" | grep "pod name:";
done
```
{% endnavtab %}

{% navtab Response %}
```bash
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-6jrmn
```
{% endnavtab %}
{% endnavtabs %}

Increasing the replicas redistributes some subsequent requests onto the new
replica:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch deploy echo --patch '{"spec": {"replicas": 3}}'
```
{% endnavtab %}

{% navtab Response %}
```bash
deployment.apps/echo patched
```
{% endnavtab %}
{% endnavtabs %}

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..3}; do
  curl -s $PROXY_IP/foo -H "x-lb: foo" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: bar" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: baz" | grep "pod name:";
done
```
{% endnavtab %}

{% navtab Response %}
```bash
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-d477r
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-d477r
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-d477r
	pod name:	echo-588c888c78-6jrmn
```
{% endnavtab %}
{% endnavtabs %}

Kong's load balancer doesn't directly distribute requests to each of the
Service's Endpoints. It first distributes them evenly across a number of
equal-size buckets. These buckets are then distributed across the available
Endpoints according to their weight. For Ingresses, however, there is only one
Service, and the controller assigns each Endpoint (represented by a Kong
upstream target) equal weight. In this case, requests are evenly hashed across all
Endpoints.

Gateway API HTTPRoute rules support distributing traffic across multiple
Services. The rule can assign weights to the Services to change the proportion
of requests an individual Service receives. In Kong's implementation, all
Endpoints of a Service have the same weight. Kong calculates a per-Endpoint
upstream target weight such that the aggregate target weight of the Endpoints
is equal to the proportion indicated by the HTTPRoute weight.

For example, say you have two Services with the following configuration:
 * One Service has four Endpoints
 * The other Service has two Endpoints
 * Each Service has weight `50` in the HTTPRoute

The targets created for the two-Endpoint Service have double the
weight of the targets created for the four-Endpoint Service (two weight `16`
targets and four weight `8` targets). Scaling the
four-Endpoint Service to eight would halve the weight of its targets (two
weight `16` targets and eight weight `4` targets).

KongUpstreamPolicy can also configure upstream [health checking behavior](/gateway/latest/reference/health-checks-circuit-breakers/) as well. See [the
KongUpstreamPolicy reference](/kubernetes-ingress-controller/{{page.kong_version}}/references/custom-resources/#kongupstreampolicy)
for the health check fields.
