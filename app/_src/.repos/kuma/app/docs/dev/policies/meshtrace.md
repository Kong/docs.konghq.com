---
title: MeshTrace (beta)
---

{% warning %}
This policy uses new policy matching algorithm and is in beta state,
it should not be mixed with [TrafficTrace](../traffic-trace).
{% endwarning %}

This policy enables publishing traces to a third party tracing solution.

Tracing is supported over HTTP, HTTP2, and gRPC protocols.
You must [explicitly specify the protocol](../protocol-support-in-kuma) for each service and data plane proxy you want to enable tracing for.

{{site.mesh_product_name}} currently supports the following trace exposition formats:

- `zipkin` traces in this format can be sent to [many different tracing backends](https://github.com/openzipkin/openzipkin.github.io/issues/65)
- `datadog`

{% warning %}
Services still need to be instrumented to preserve the trace chain across requests made across different services.

You can instrument with a language library of your choice ([for zipkin](https://zipkin.io/pages/tracers_instrumentation) and [for datadog](https://docs.datadoghq.com/tracing/setup_overview/setup/java/?tab=containers)).
For HTTP you can also manually forward the following headers:

- `x-request-id`
- `x-b3-traceid`
- `x-b3-parentspanid`
- `x-b3-spanid`
- `x-b3-sampled`
- `x-b3-flags`
{% endwarning %}

## TargetRef support matrix

| TargetRef type    | top level | to  | from |
| ----------------- | --------- | --- | ---- |
| Mesh              | ✅        | ❌  | ❌   |
| MeshSubset        | ✅        | ❌  | ❌   |
| MeshService       | ✅        | ❌  | ❌   |
| MeshServiceSubset | ✅        | ❌  | ❌   |
| MeshGatewayRoute  | ✅        | ❌  | ❌   |

To learn more about the information in this table, see the [matching docs](/docs/{{ page.version }}/policies/targetref).

## Configuration

### Sampling

{% tip %}
Most of the time setting only `overall` is sufficient. `random` and `client` are for advanced use cases.
{% endtip %}

You can configure sampling settings equivalent to Envoy's:

- [overall](https://www.envoyproxy.io/docs/envoy/v1.22.5/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto.html?highlight=overall_sampling#extensions-filters-network-http-connection-manager-v3-httpconnectionmanager-tracing)
- [random](https://www.envoyproxy.io/docs/envoy/v1.22.5/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto.html?highlight=random_sampling#extensions-filters-network-http-connection-manager-v3-httpconnectionmanager-tracing)
- [client](https://www.envoyproxy.io/docs/envoy/v1.22.5/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto.html?highlight=client_sampling#extensions-filters-network-http-connection-manager-v3-httpconnectionmanager-tracing)

The value is always a percentage and is between 0 and 100.

Example:

```yaml
sampling:
  overall:
    value: 80
  random:
    value: 60
  client:
    value: 40
```

### Tags

You can add tags to trace metadata by directly supplying the value (`literal`) or by taking it from a header (`header`).

Example:

```yaml
tags:
  - name: team
    literal: core
  - name: env
    header:
      name: x-env
      default: prod
  - name: version
    header:
      name: x-version
```

If a value is missing for `header`, `default` is used.
If `default` isn't provided, then the tag won't be added.

### Backends

#### Datadog

You can configure a Datadog backend with a `url` and `splitService`.

Example:
```yaml
datadog:
  url: http://my-agent:8080 # Required. The url to reach a running datadog agent
  splitService: true # Default to false. If true, it will split inbound and outbound requests in different services in Datadog
```

The `splitService` property determines if Datadog service names should be split based on traffic direction and destination.
For example, with `splitService: true` and a `backend` service that communicates with a couple of databases,
you would get service names like `backend_INBOUND`, `backend_OUTBOUND_db1`, and `backend_OUTBOUND_db2` in Datadog.

#### Zipkin

In most cases the only field you'll want to set in `url`.

Example:
```yaml
zipkin:
  url: http://jaeger-collector:9411/api/v2/spans # Required. The url to a zipkin collector to send traces to 
  traceId128bit: false # Default to false which will expose a 64bits traceId. If true, the id of the trace is 128bits
  apiVersion: httpJson # Default to httpJson. It can be httpJson, httpProto and is the version of the zipkin API
  sharedSpanContext: false # Default to true. If true, the inbound and outbound traffic will share the same span. 
```

## Examples

### Zipkin

{% tabs meshtrace-zipkin useUrlFragment=false %}
{% tab meshtrace-zipkin Kubernetes %}

Simple example:
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshTrace
metadata:
  name: default
  namespace: {{site.default_namespace}}
  labels:
    kuma.io/mesh: default # optional, defaults to `default` if unset
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - zipkin:
          url: http://jaeger-collector.mesh-observability:9411/api/v2/spans
```

Full example:
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshTrace
metadata:
  name: default
  namespace: {{site.default_namespace}}
  labels:
    kuma.io/mesh: default # optional, defaults to `default` if unset
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - zipkin:
          url: http://jaeger-collector.mesh-observability:9411/api/v2/spans
          apiVersion: httpJson
    tags:
      - name: team
        literal: core
      - name: env
        header:
          name: x-env
          default: prod
      - name: version
        header:
          name: x-version
    sampling:
      overall:
        value: 80
      random:
        value: 60
      client:
        value: 40
```

Apply the configuration with `kubectl apply -f [..]`.

{% endtab %}
{% tab meshtrace-zipkin Universal %}

Simple example:
```yaml
type: MeshTrace
name: default
mesh: default
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - zipkin:
          url: http://jaeger-collector:9411/api/v2/spans
```

Full example:
```yaml
type: MeshTrace
name: default
mesh: default
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - zipkin:
          url: http://jaeger-collector:9411/api/v2/spans
          apiVersion: httpJson
    tags:
      - name: team
        literal: core
      - name: env
        header:
          name: x-env
          default: prod
      - name: version
        header:
          name: x-version
    sampling:
      overall:
        value: 80
      random:
        value: 60
      client:
        value: 40
```

Apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](../../reference/http-api).

{% endtab %}
{% endtabs %}

### Datadog

{% tip %}
This assumes a Datadog agent is configured and running. If you haven't already check the [Datadog observability page](../../explore/observability#configuring-datadog).
{% endtip %}

{% tabs meshtrace-datadog useUrlFragment=false %}
{% tab meshtrace-datadog Kubernetes %}

Simple Example:
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshTrace
metadata:
  name: default
  namespace: {{site.default_namespace}}
  labels:
    kuma.io/mesh: default # optional, defaults to `default` if unset
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - datadog:
          url: http://trace-svc.default.svc.cluster.local:8126
```

Full Example:
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshTrace
metadata:
  name: default
  namespace: {{site.default_namespace}}
  labels:
    kuma.io/mesh: default # optional, defaults to `default` if unset
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - datadog:
          url: http://trace-svc.default.svc.cluster.local:8126
          splitService: true
    tags:
      - name: team
        literal: core
      - name: env
        header:
          name: x-env
          default: prod
      - name: version
        header:
          name: x-version
    sampling:
      overall:
        value: 80
      random:
        value: 60
      client:
        value: 40
```

where `trace-svc` is the name of the Kubernetes Service you specified when you configured the Datadog APM agent.

Apply the configuration with `kubectl apply -f [..]`.

{% endtab %}
{% tab meshtrace-datadog Universal %}

Simple example:
```yaml
type: MeshTrace
name: default
mesh: default
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - datadog:
          url: http://127.0.0.1:8126
```

Full example:
```yaml
type: MeshTrace
name: default
mesh: default
spec:
  targetRef:
    kind: Mesh
  default:
    backends:
      - datadog:
          url: http://127.0.0.1:8126
          splitService: true
    tags:
      - name: team
        literal: core
      - name: env
        header:
          name: x-env
          default: prod
      - name: version
        header:
          name: x-version
    sampling:
      overall:
        value: 80
      random:
        value: 60
      client:
        value: 40
```

Apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](../../reference/http-api).

{% endtab %}
{% endtabs %}

### Targeting parts of the infrastructure

While usually you want all the traces to be sent to the same tracing backend,
you can target parts of a `Mesh` by using a finer-grained `targetRef` and a designated backend to trace different paths of our service traffic.
This is especially useful when you want traces to never leave a world region, or a cloud, for example.

In this example, we have two zones `east` and `west`, each of these with their own Zipkin collector: `east.zipkincollector:9411/api/v2/spans` and `west.zipkincollector:9411/api/v2/spans`.
We want dataplane proxies in each zone to only send traces to their local collector.

To do this, we use a `TargetRef` kind value of `MeshSubset` to filter which dataplane proxy a policy applies to.

{% tabs meshtrace-region useUrlFragment=false %}
{% tab meshtrace-region Universal %}

West only policy:
```yaml
type: MeshTrace
name: trace-west
mesh: default
spec:
  targetRef:
    kind: MeshSubset
    tags:
      kuma.io/zome: west
  default:
    backends:
      - zipkin:
          url: http://west.zipkincollector:9411/api/v2/spans
```

East only policy:
```yaml
type: MeshTrace
name: trace-east
mesh: default
spec:
  targetRef:
    kind: MeshSubset
    tags:
      kuma.io/zome: east
  default:
    backends:
      - zipkin:
          url: http://east.zipkincollector:9411/api/v2/spans
```
{% endtab %}
{% tab meshtrace-region Kubernetes %}
West only policy:
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshTrace
metadata:
    name: trace-west
    namespace: {{site.default_namespace}}
spec:
  targetRef:
    kind: MeshSubset
    tags:
      kuma.io/zome: west
  default:
    backends:
      - zipkin:
          url: http://west.zipkincollector:9411/api/v2/spans
```

East only policy:
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshTrace
metadata:
  name: trace-east
  namespace: {{site.default_namespace}}
spec:
  targetRef:
    kind: MeshSubset
    tags:
      kuma.io/zome: east
  default:
    backends:
      - zipkin:
          url: http://east.zipkincollector:9411/api/v2/spans
```
{% endtab %}
{% endtabs %}
