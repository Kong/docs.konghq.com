---
title: Annotations in Kubernetes mode
---

This page provide a complete list of all the annotations you can specify when you run Kuma in Kubernetes mode.

### `kuma.io/mesh`

Associates a given Pod with a particular Mesh. Annotation value must be the name of a Mesh resource.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: backend
 annotations:
   kuma.io/mesh: default
[...]
```

### `kuma.io/sidecar-injection`

Lets you enable or disable sidecar injection.

**Example**

```yaml
apiVersion: v1
kind: Namespace
metadata:
 name: default
 annotations:
   kuma.io/sidecar-injection: enabled
[...]
```

### `kuma.io/gateway`

Lets you specify the Pod should run in gateway mode. Inbound listeners are not generated.

**Example**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gateway
spec:
  selector:
    matchLabels:
      app: gateway
  template:
    metadata:
      labels:
        app: gateway
      annotations:
        kuma.io/gateway: enabled
[...]
```

### `kuma.io/ingress`

Marks the Pod as the Zone Ingress. Needed for multizone communication -- provides the entry point for traffic from other zones.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: zone-ingress
 annotations:
   kuma.io/ingress: enabled
[...]
```

### `kuma.io/ingress-public-address`

Specifies the public address for Ingress. If not provided, Kuma picks the address from the Ingress Service.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: zone-ingress
 annotations:
   kuma.io/ingress: enabled
   kuma.io/ingress-public-address: custom-address.com
[...]
```

### `kuma.io/ingress-public-port`

Specifies the public port for Ingress. If not provided, Kuma picks the port from the Ingress Service.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: zone-ingress
 annotations:
   kuma.io/ingress: enabled
   kuma.io/ingress-public-port: "1234"
[...]
```

### `kuma.io/direct-access-services`

Defines a comma-separated list of Services that can be accessed directly.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    kuma.io/direct-access-services: test-app_playground_svc_80,test-app_playground_svc_443
    kuma.io/transparent-proxying: enabled
    kuma.io/transparent-proxying-inbound-port: [...]
    kuma.io/transparent-proxying-outbound-port: [...]
```

When you provide this annotation, Kuma generates a listener for each IP address and redirects traffic through a `direct-access` cluster that's configured to encrypt connections.

These listeners are needed because transparent proxy and mTLS assume a single IP per cluster (for example, the ClusterIP of a Kubernetes Service). If you pass requests to direct IP addresses, Envoy considers them unknown destinations and manages them in passthrough mode -- which means they're not encrypted with mTLS. The `direct-access` cluster enables encryption anyway.

{% warning %}
**WARNING**: You should specify this annotation only if you really need it. Generating listeners for every endpoint makes the xDS snapshot very large.
{% endwarning %}

### `kuma.io/virtual-probes`

Enables automatic converting of HttpGet probes to virtual probes. The virtual probe is served on a sub-path of the insecure port specified with `kuma.io/virtual-probes-port` -- for example, `:8080/health/readiness` -> `:9000/8080/health/readiness`, where `9000` is the value of the `kuma.io/virtual-probes-port` annotation.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    kuma.io/virtual-probes: enabled
    kuma.io/virtual-probes-port: "9000"
[...]
```

### `kuma.io/virtual-probes-port`

Specifies the insecure port for listening on virtual probes.

### `kuma.io/sidecar-env-vars`

Semicolon (`;`) separated list of environment variables for the Kuma sidecar.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    kuma.io/sidecar-env-vars: TEST1=1;TEST2=2 
```

### `prometheus.metrics.kuma.io/port`

Lets you override the `Mesh`-wide default port that Prometheus should scrape metrics from.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    prometheus.metrics.kuma.io/port: "1234"
```

### `prometheus.metrics.kuma.io/path`

Lets you override the `Mesh`-wide default path that Prometheus should scrape metrics from.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    prometheus.metrics.kuma.io/path: "/custom-metrics"
```

### `kuma.io/builtindns`

Tells the sidecar to use its builtin DNS server.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    kuma.io/builtindns: enabled
```

### `kuma.io/builtindnsport`

Port the builtin DNS server should listen on for DNS queries.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    kuma.io/builtindns: enabled
    kuma.io/builtindnsport: "15053"
```

### `traffic.kuma.io/exclude-inbound-ports`

List of inbound ports to exclude from traffic interception by the Kuma sidecar.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    traffic.kuma.io/exclude-inbound-ports: "1234,1235"
```

### `traffic.kuma.io/exclude-outbound-ports`

List of outbound ports to exclude from traffic interception by the Kuma sidecar.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    traffic.kuma.io/exclude-outbound-ports: "1234,1235"
```
