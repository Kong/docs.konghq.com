---
title: Annotations and labels in Kubernetes mode
---

This page provide a complete list of all the annotations you can specify when you run Kuma in Kubernetes mode.

## Labels

### `kuma.io/sidecar-injection`

Enable or disable sidecar injection.

**Example**

Used on the namespace it will inject the sidecar in all pods created in the namespace:

```yaml
apiVersion: v1
kind: Namespace
metadata:
 name: default
 labels:
   kuma.io/sidecar-injection: enabled
[...]
```

Used on a deployment using pod template it will inject the sidecar in all pods managed by this deployment:

```yaml
apiVersion: v1
king: Deployment
metadata:
  name: my-deployment
spec:
  template:
    metadata:
      labels:
        kuma.io/sidecar-injection: enabled
[...]
```

Labeling pods or deployments will take precedence on the namespace annotation.

## Annotations

### `kuma.io/mesh`

Associate Pods with a particular Mesh. Annotation value must be the name of a Mesh resource.

**Example**

It can be used on an entire namespace:

```yaml
apiVersion: v1
kind: Namespace
metadata:
 name: default
 annotations:
   kuma.io/mesh: default
[...]
```

It can be used on a pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: backend
 annotations:
   kuma.io/mesh: default
[...]
```

Annotating pods or deployments will take precedence on the namespace annotation.

### `kuma.io/sidecar-injection`

Similar to the prefered [label](#kumaiosidecar-injection).

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

{% warning %}
While you can still use annotations to inject sidecar, we strongly recommend using labels.
It's the only way to guarantee that application can only be started with sidecar.
{% endwarning %}

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

### `kuma.io/ignore`

A boolean to mark a resource as ignored by Kuma.
It currently only works for services.
This is useful when transitioning to Kuma or to temporarily ignore some entities.

**Example**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example
  annotations:
    kuma.io/ignore: "true"
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

### `kuma.io/envoy-admin-port`

Specifies the port for Envoy Admin API. If not set, default admin port 9901 will be used.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    kuma.io/envoy-admin-port: "8801"
```

### `kuma.io/service-account-token-volume`

Volume (specified in the pod spec) containing a service account token for Kuma to inject into the sidecar.

**Example**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  annotations:
    kuma.io/service-account-token-volume: "token-vol"
spec:
  automountServiceAccountToken: false
  serviceAccount: example
  containers:
    - image: busybox
      name: busybox
  volumes:
    - name: token-vol
      projected:
        sources:
          - serviceAccountToken:
              expirationSeconds: 7200
              path: token
              audience: "https://kubernetes.default.svc"
          - configMap:
              items:
                - key: ca.crt
                  path: ca.crt
              name: kube-root-ca.crt
          - downwardAPI:
              items:
                - fieldRef:
                    apiVersion: v1
                    fieldPath: metadata.namespace
                  path: namespace
```

### `kuma.io/transparent-proxying-reachable-services`

A comma separated list of `kuma.io/service` to indicate which services this communicates with.
For more details see the [reachable services docs](/docs/{{ page.version }}/networking/transparent-proxying#reachable-services).

**Example**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
  namespace: kuma-example
spec:
  ...
  template:
    metadata:
      ...
      annotations:
        # a comma separated list of kuma.io/service values
        kuma.io/transparent-proxying-reachable-services: "redis_kuma-demo_svc_6379,elastic_kuma-demo_svc_9200"
    spec:
      containers:
        ...
```
