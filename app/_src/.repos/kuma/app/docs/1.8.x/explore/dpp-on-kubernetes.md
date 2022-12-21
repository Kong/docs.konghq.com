---
title: Data plane on Kubernetes
---

On Kubernetes the [`Dataplane`](/docs/{{ page.version }}/explore/dpp#dataplane-entity) entity is automatically created for you, and because transparent proxying is used to communicate between the service and the sidecar proxy, no code changes are required in your applications.

You can control where Kuma automatically injects the data plane proxy by **labeling** either the Namespace or the Pod with
`kuma.io/sidecar-injection=enabled`, e.g.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: kuma-example
  labels:
    # inject Kuma sidecar into every Pod in that Namespace,
    # unless a user explicitly opts out on per-Pod basis
    kuma.io/sidecar-injection: enabled
```

To opt out of data-plane injection into a particular `Pod`, you need to **label** it
with `kuma.io/sidecar-injection=disabled`, e.g.

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
      labels:
        # indicate to Kuma that this Pod doesn't need a sidecar
        kuma.io/sidecar-injection: disabled
    spec:
      containers:
        ...
```
{% warning %}
In previous versions the recommended way was to use annotations.
While annotations are still supported, we strongly recommend using labels.
This is the only way to guarantee that applications can only be started with sidecar.
{% endwarning %}

Once your pod is running you can see the data plane CRD that matches it using `kubectl`:

```shell
kubectl get dataplanes <podName>
```

## Tag generation

When `Dataplane` entities are automatically created, all labels from Pod are converted into `Dataplane` tags.
Labels with keys that contains `kuma.io/` are not converted because they are reserved to Kuma.
The following tags are added automatically and cannot be overridden using Pod labels.

* `kuma.io/service`: Identifies the service name based on a Service that selects a Pod. This will be of format `<name>_<namespace>_svc_<port>` where `<name>`, `<namespace>` and `<port>` are from the Kubernetes service that is associated with this particular pod.
  When a pod is spawned without being associated with any Kubernetes Service resource the data plane tag will be `kuma.io/service: <name>_<namespace>_svc`, where `<name>` and`<namespace>` are extracted from the Pod resource metadata.
* `kuma.io/zone`: Identifies the zone name in a [multi-zone deployment](/docs/{{ page.version }}/deployments/multi-zone).
* `kuma.io/protocol`: Identifies [the protocol](/docs/{{ page.version }}/policies/protocol-support-in-kuma) that was defined by the `appProtocol` field on the Service that selects the Pod.
* `k8s.kuma.io/namespace`: Identifies the Pod's namespace. Example: `kuma-demo`.
* `k8s.kuma.io/service-name`: Identifies the name of Kubernetes Service that selects the Pod. Example: `demo-app`.
* `k8s.kuma.io/service-port`: Identifies the port of Kubernetes Service that selects the Pod. Example: `80`.

{% tip %}
- If a Kubernetes service exposes more than 1 port, multiple inbounds will be generated all with different `kuma.io/service`.
- If a pod is attached to more than one Kubernetes service, multiple inbounds will also be generated. 
{% endtip %}

### Example

```yaml
apiVersion: v1
kind: Pod
metadata: 
  name: my-app
  namespace: my-namespace
  labels:
    foo: bar
    app: my-app
spec:
  # ...
---
apiVersion: v1
kind: Service
metadata:
  name: my-service
  namespace: my-namespace
spec:
  selector:
    app: my-app
  type: ClusterIP
  ports:
    - name: port1
      protocol: TCP
      appProtocol: http
      port: 80
      targetPort: 8080
    - name: port2
      protocol: TCP
      appProtocol: grpc
      port: 1200
      targetPort: 8081
---
apiVersion: v1
kind: Service
metadata:
  name: my-other-service
  namespace: my-namespace
spec:
  selector:
    foo: bar 
  type: ClusterIP
  ports:
    - protocol: TCP
      appProtocol: http
      port: 81
      targetPort: 8080
```

Will generate the following inbounds in your Kuma dataplane:

```yaml
...
inbound:
  - port: 8080
    tags:
      kuma.io/protocol: http
      kuma.io/service: my-service_my-namespace_svc_80
      k8s.kuma.io/service-name: my-service
      k8s.kuma.io/service-port: "80"
      k8s.kuma.io/namespace: my-namespace
      # Labels coming from your pod
      app: my-app
      foo: bar
  - port: 8081
    tags:
      kuma.io/protocol: grpc
      kuma.io/service: my-service_my-namespace_svc_1200
      k8s.kuma.io/service-name: my-service
      k8s.kuma.io/service-port: "1200"
      k8s.kuma.io/namespace: my-namespace
      # Labels coming from your pod
      app: my-app
      foo: bar
  - port: 8080
    tags:
      kuma.io/protocol: http
      kuma.io/service: my-other-service_my-namespace_svc_81
      k8s.kuma.io/service-name: my-other-service
      k8s.kuma.io/service-port: "81"
      k8s.kuma.io/namespace: my-namespace
      # Labels coming from your pod
      app: my-app
      foo: bar
```

Notice how `kuma.io/service` is built on `<serviceName>_<namespace>_svc_<port>` and `kuma.io/protocol` is the `appProtocol` field of your service entry.

## Lifecycle

### Joining the mesh

On Kubernetes, `Dataplane` resource is automatically created by kuma-cp. For each Pod with sidecar-injection label a new
`Dataplane` resource will be created.

To join the mesh in a graceful way, we need to first make sure the application is ready to serve traffic before it can be considered a valid traffic destination.

When Pod is converted to a `Dataplane` object it will be marked as unhealthy until Kubernetes considers all containers to be ready.

### Leaving the mesh

To leave the mesh in a graceful shutdown, we need to remove the traffic destination from all the clients before shutting it down.

When the Kuma DP sidecar receives a `SIGTERM` signal it does in this order:

1) start draining Envoy listeners
2) wait for the entire draining time
3) stop the sidecar process
During the draining process, Envoy can still accept connections however:
1) It is marked as unhealthy on Envoy Admin `/ready` endpoint
2) It sends `connection: close` for HTTP/1.1 requests and GOAWAY frame for HTTP/2.
   This forces clients to close a connection and reconnect to the new instance.

You can read [Kubernetes docs](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination) to learn how Kubernetes handles pod lifecycle. Here is the summary with relevant parts for Kuma.

Whenever a user or system deletes a Pod, Kubernetes does the following:
1) It marks the Pod as terminated
2) Concurrently for every container it:
    1) Executes any pre stop hook if defined
    2) Sends a SIGTERM signal
    3) Waits until container is terminated for maximum of graceful termination time (by default 60s)
    4) Sends a SIGKILL to the container
3) It removes the Pod object from the system

When Pod is marked as terminated, Kuma CP updates Dataplane object to be unhealthy which will trigger configuration update to all the clients to remove it as a destination.
This can take a couple of seconds depending on the size of the mesh, available resources for CP, XDS configuration interval, etc.

If the application next to the Kuma DP sidecar quits immediately after the SIGTERM signal, there is a high chance that clients will still try to send traffic to this destination.

To mitigate this, we need to either
* Support graceful shutdown in the application. For example, the application should wait X seconds to exit after receiving the first SIGTERM signal.
* Add a pre-stop hook to postpone stopping the application container. Example:
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: redis
  spec:
    template:
      spec:
        containers:
        - name: redis
          image: "redis"
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sleep", "30"]
  ```

When a Pod is deleted its matching `Dataplane` resource is deleted as well. This is possible thanks to the
[owner reference](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/) set on the `Dataplane` resource.

## Custom Container Configuration

If you want to modify the default container configuration you can use
the `ContainerPatch` Kubernetes CRD. It allows configuration of both sidecar
and init containers. `ContainerPatch` resources are namespace scoped and can
only be applied in a namespace where **Kuma CP** is running.

{% warning %}
In the vast majority of cases you shouldn't need to override the sidecar and
init-container configurations. `ContainerPatch` is a feature which requires good
understanding of both Kuma and Kubernetes.
{% endwarning %}

The specification of `ContainerPatch` consists of the list of [jsonpatch](https://datatracker.ietf.org/doc/html/rfc6902)
strings which describe the modifications to be performed.

### Example

{% warning %}
When using ContainerPath, every `value` field must be valid JSON.
{% endwarning %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: ContainerPatch
metadata:
  name: container-patch-1
  namespace: kuma-system
spec:
  sidecarPatch:
    - op: add
      path: /securityContext/privileged
      value: "true"
    - op: add
      path: /resources/requests/cpu
      value: '"100m"'
    - op: add
      path: /resources/limits
      value: '{
        "cpu": "500m",
        "memory": "256Mi"
      }'
  initPatch:
    - op: add
      path: /securityContext/runAsNonRoot
      value: "true"
    - op: remove
      path: /securityContext/runAsUser
```

This will change the `securityContext` section of `kuma-sidecar` container from:

```yaml
securityContext:
  runAsGroup: 5678
  runAsUser: 5678
```

to:

```yaml
securityContext:
  runAsGroup: 5678
  runAsUser: 5678
  privileged: true
```

and similarly change the securityContext section of the init container from:

```yaml
securityContext:
  capabilities:
    add:
    - NET_ADMIN
    - NET_RAW
  runAsGroup: 0
  runAsUser: 0
```

to:

```yaml
securityContext:
  capabilities:
    add:
    - NET_ADMIN
    - NET_RAW
  runAsGroup: 0
  runAsNonRoot: true
```

Resources `requests cpu` will be changed from: 

```yaml
requests:                                                                                                       │
  cpu: 50m
```

to: 

```yaml
requests:                                                                                                       │
  cpu: 100m
```

Resources `limits` will be changed from: 

```yaml
limits:
  cpu: 1000m
  memory: 512Mi
```

to: 

```yaml
limits:
  cpu: 500m
  memory: 256Mi
```

### Workload matching

A `ContainerPatch` is matched to a `Pod` via an `kuma.io/container-patches`
annotation on the workload. Each annotation may be an ordered list of
`ContainerPatch` names, which will be applied in the order specified.

{% warning %}
If a workload refers to a `ContainerPatch` which does not exist, the injection
will explicitly fail and log the failure.
{% endwarning %}

#### Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: app-ns
  name: app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-deployment
  template:
    metadata:
      labels:
        app: app-deployment
      annotations:
        kuma.io/container-patches: container-patch-1,container-patch-2
    spec: [...]
```

### Default patches 

You can configure `kuma-cp` to apply the list of default patches for workloads
which don't specify their own patches by modifying the `containerPatches` value
from the `kuma-dp` configuration:

```yaml
[...]
runtime:
  kubernetes:
    injector:
      containerPatches: [ ]
[...]
```

{% tip %}
If you specify the list of default patches (i.e. `["default-patch-1", "default-patch-2]`)
but your workload will be annotated with its own list of patches (i.e.
`["pod-patch-1", "pod-patch-2]`) only the latter will be applied. 
{% endtip %}

#### Example

```shell
kumactl install control-plane --env-var "KUMA_RUNTIME_KUBERNETES_INJECTOR_CONTAINER_PATCHES=patch1,patch2"
```

### Error modes and validation

When applying `ContainerPatch` Kuma will validate that the rendered container
spec meets the Kubernetes specification. Kuma **will not** validate that it is
a sane configuration.

If a workload refers to a `ContainerPatch` which does not exist, the injection
will explicitly fail and log the failure.

## Direct access to services

By default, on Kubernetes data plane proxies communicate with each other by leveraging the `ClusterIP` address of the `Service` resources. Also by default, any request made to another service is automatically load balanced client-side by the data plane proxy that originates the request (they are load balanced by the local Envoy proxy sidecar proxy).

There are situations where we may want to bypass the client-side load balancing and directly access services by using their IP address (ie: in the case of Prometheus wanting to scrape metrics from services by their individual IP address).

When an originating service wants to directly consume other services by their IP address, the originating service's `Deployment` resource must include the following annotation:

```yaml
kuma.io/direct-access-services: Service1, Service2, ServiceN
```

Where the value is a comma separated list of Kuma services that will be consumed directly. For example:

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
        kuma.io/direct-access-services: "backend_example_svc_1234,backend_example_svc_1235"
    spec:
      containers:
        ...
```

We can also use `*` to indicate direct access to every service in the Mesh:

```yaml
kuma.io/direct-access-services: *
```

{% warning %}
Using `*` to directly access every service is a resource intensive operation, so we must use it carefully.
{% endwarning %}
