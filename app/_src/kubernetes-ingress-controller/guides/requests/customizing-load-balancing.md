---
title: Customizing load-balancing behavior with KongUpstreamPolicy
---

In this guide, we will learn how to use KongUpstreamPolicy resource to control
proxy load-balancing behavior.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

{% include_cached /md/kic/test-service-echo.md kong_version=page.kong_version %}

### Deploy additional echo replicas

To demonstrate Kong's load balancing functionality we need multiple `echo` Pods. Scale out the `echo` deployment.

```bash
kubectl scale --replicas 2 deployment echo
```

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version path='/echo' name='echo' service='echo' port='1027' skip_host=true no_indent=true %}

## Use KongUpstreamPolicy with a Service resource

By default, Kong will round-robin requests between upstream replicas. If you
run `curl -s $PROXY_IP/echo | grep "Pod"` repeatedly, you should see the
reported Pod name alternate between two values.

You can configure the Kong upstream associated with the Service to use a
different [load balancing strategy](/gateway/latest/how-kong-works/load-balancing/#balancing-algorithms), such as consistently sending requests to the same upstream based on a header value (please see the [KongUpstreamPolicy reference](/kubernetes-ingress-controller/{{page.kong_version}}/reference/custom-resources/#kongupstreampolicy) for the full list of supported algorithms and their configuration options).

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

With consistent hashing and client IP fallback, sending repeated requests without any `x-lb` header now sends them to the same Pod:

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..5}; do curl -s $PROXY_IP/echo | grep "Pod"; done
```
{% endnavtab %}

{% navtab Response %}
```bash
Running on Pod echo-965f7cf84-frpjc.
Running on Pod echo-965f7cf84-frpjc.
Running on Pod echo-965f7cf84-frpjc.
Running on Pod echo-965f7cf84-frpjc.
Running on Pod echo-965f7cf84-frpjc.
```
{% endnavtab %}
{% endnavtabs %}

If you add the header, Kong hashes its value and distributes it to the
same replica when using the same value:

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..3}; do
  curl -s $PROXY_IP/echo -H "x-lb: foo" | grep "Pod";
  curl -s $PROXY_IP/echo -H "x-lb: bar" | grep "Pod";
  curl -s $PROXY_IP/echo -H "x-lb: baz" | grep "Pod";
done
```
{% endnavtab %}

{% navtab Response %}
```bash
Running on Pod echo-965f7cf84-wlvw9.
Running on Pod echo-965f7cf84-frpjc.
Running on Pod echo-965f7cf84-wlvw9.
Running on Pod echo-965f7cf84-wlvw9.
Running on Pod echo-965f7cf84-frpjc.
Running on Pod echo-965f7cf84-wlvw9.
Running on Pod echo-965f7cf84-wlvw9.
Running on Pod echo-965f7cf84-frpjc.
Running on Pod echo-965f7cf84-wlvw9.
```
{% endnavtab %}
{% endnavtabs %}

Increasing the replicas redistributes some subsequent requests onto the new
replica:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl scale --replicas 3 deployment echo
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
  curl -s $PROXY_IP/echo -H "x-lb: foo" | grep "Pod";
  curl -s $PROXY_IP/echo -H "x-lb: bar" | grep "Pod";
  curl -s $PROXY_IP/echo -H "x-lb: baz" | grep "Pod";
done
```
{% endnavtab %}

{% navtab Response %}
```bash
Running on Pod echo-965f7cf84-5h56p.
Running on Pod echo-965f7cf84-5h56p.
Running on Pod echo-965f7cf84-wlvw9.
Running on Pod echo-965f7cf84-5h56p.
Running on Pod echo-965f7cf84-5h56p.
Running on Pod echo-965f7cf84-wlvw9.
Running on Pod echo-965f7cf84-5h56p.
Running on Pod echo-965f7cf84-5h56p.
Running on Pod echo-965f7cf84-wlvw9.
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
KongUpstreamPolicy reference](/kubernetes-ingress-controller/{{page.release}}/reference/custom-resources/#kongupstreampolicy) for the health check fields.
