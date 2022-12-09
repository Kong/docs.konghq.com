---
title: Traffic Trace
---

This policy enables tracing logging to a third party tracing solution. 

{% tip %}
Tracing is supported on any HTTP traffic in a [`Mesh`](/docs/{{ page.version }}/policies/mesh), and will only work with data plane proxies and services that have the Kuma `kuma.io/protocol: http` tag defined.
Check the [protocol support](/docs/{{ page.version }}/policies/protocol-support-in-kuma/) for more details on how to set the protocol tag in the different environments.
{% endtip %}

In order to enable tracing there are two steps that have to be taken:

* [1. Add a tracing backend](#add-a-tracing-backend)
* [2. Add a TrafficTrace resource](#add-a-traffictrace-resource)

{% tip %}
On Kubernetes we can run `kumactl install tracing | kubectl apply -f -` to deploy Jaeger automatically in a `kuma-tracing` namespace.
{% endtip %}

## Add a tracing backend

A tracing backend must be first specified in a [`Mesh`](/docs/{{ page.version }}/policies/mesh) resource. Once added, the tracing backend will be available for use in the `TrafficTrace` resource.

{% tip %}
While most commonly we want all the traces to be sent to the same tracing backend, we can optionally create multiple tracing backends in a `Mesh` resource and store traces for different paths of our service traffic in different backends (by leveraging Kuma Tags). This is especially useful when we want traces to never leave a world region, or a cloud, among other examples.
{% endtip %}

The types supported are:

* `zipkin`. You can also use this with [Jaeger](https://www.jaegertracing.io/) since it supports Zipkin compatible traces.

To add a new tracing backend we must create a new `tracing` property in a `Mesh` resource:

{% tabs tracing-backend useUrlFragment=false %}
{% tab tracing-backend Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  tracing:
    defaultBackend: jaeger-collector
    backends:
    - name: jaeger-collector
      type: zipkin
      sampling: 100.0
      conf:
        url: http://jaeger-collector.kuma-tracing:9411/api/v2/spans
```

We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab tracing-backend Universal %}
```yaml
type: Mesh
name: default
tracing:
  defaultBackend: jaeger-collector
  backends:
  - name: jaeger-collector
    type: zipkin
    sampling: 100.0
    conf:
      url: http://jaeger-collector.kuma-tracing:9411/api/v2/spans
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}

We can also specify a `defaultBackend` property that will be used if any `TrafficTrace` resource doesn't explicitly specify a tracing backend.

## Add a TrafficTrace resource

Once we have added a tracing backend, we can now create `TrafficTrace` resources that will determine how we are going to collecting traces, and what backend we should be using to store them.

{% tabs traffic-trace useUrlFragment=false %}
{% tab traffic-trace Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficTrace
mesh: default
metadata:
  name: trace-all-traffic
spec:
  selectors:
  - match:
      kuma.io/service: '*'
  conf:
    backend: jaeger-collector
```

We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab traffic-trace Universal %}
```yaml
type: TrafficTrace
name: trace-all-traffic
mesh: default
selectors:
- match:
    kuma.io/service: '*'
conf:
  backend: jager-collector
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}

We can use Kuma Tags to apply the `TrafficTrace` resource in a more target way to a subset of data plane proxies as opposed to all of them (like we do in the example by using the `kuma.io/service: '*'` selector),

It is important that we instrument our services to preserve the trace chain between requests that are made across different services. We can either use a library in the language of our choice, or we can manually pass the following headers:

* `x-request-id`
* `x-b3-traceid`
* `x-b3-parentspanid`
* `x-b3-spanid`
* `x-b3-sampled`
* `x-b3-flags`

As noted before, Envoy's Zipkin tracer is also [compatible with Jaeger through Zipkin V2 HTTP API.](https://www.jaegertracing.io/docs/1.13/features/#backwards-compatibility-with-zipkin).

## Matching

`TrafficTrace` is a [Dataplane policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply#dataplane-policy). You can use all the tags in the `selectors` section.
