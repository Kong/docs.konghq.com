---
title: Data plane on Kubernetes
---

On Kubernetes the [`Dataplane`](/docs/{{ page.version }}/explore/dpp#dataplane-entity) entity is automatically created for you, and because transparent proxying is used to communicate between the service and the sidecar proxy, no code changes are required in your applications.

You can control where Kuma automatically injects the dataplane proxy by **labeling** either the Namespace or the Pod with
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

Once your pod is running you can see the dataplane CRD that matches it using `kubectl`:

```shell
kubectl get dataplanes <podName>
```

## Tag generation

When `Dataplane` entities are automatically created, all labels from Pod are converted into `Dataplane` tags.
Labels with keys that contains `kuma.io/` are not converted because they are reserved to Kuma.
The following tags are added automatically and cannot be overridden using Pod labels.

* `kuma.io/service`: Identifies the service name based on a Service that selects a Pod. This will be of format `<name>_<namespace>_svc_<port>` where `<name>`, `<namespace>` and `<port>` are from the Kubernetes service that is associated with the particular pod.
  When a pod is spawned without being associated with any Kubernetes Service resource the dataplane tag will be `kuma.io/service: <name>_<namespace>_svc`, where `<name>` and`<namespace>` are extracted from the Pod resource.
* `kuma.io/zone`: Identifies the zone name in a [multi-zone deployment](/docs/{{ page.version }}/deployments/multi-zone).
* `kuma.io/protocol`: Identifies [the protocol](/docs/{{ page.version }}/policies/protocol-support-in-kuma) that was defined on the Service that selects a Pod.
* `k8s.kuma.io/namespace`: Identifies the Pod's namespace. Example: `kuma-demo`.
* `k8s.kuma.io/service-name`: Identifies the name of Kubernetes Service that selects a Pod. Example: `demo-app`.
* `k8s.kuma.io/service-port`: Identifies the port of Kubernetes Service that selects a Pod. Example: `80`.

## Direct access to services

By default on Kubernetes data plane proxies communicate with each other by leveraging the `ClusterIP` address of the `Service` resources. Also by default, any request made to another service is automatically load balanced client-side by the data plane proxy that originates the request (they are load balanced by the local Envoy proxy sidecar proxy).

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

## Lifecycle

### Creation

On Kubernetes, `Dataplane` resource is automatically created by kuma-cp. For each Pod with sidecar-injection label a new 
`Dataplane` resource will be created. 

### Deletion

When a Pod is deleted its matching `Dataplane` resource is deleted as well. This is possible thanks to the
[owner reference](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/) set on the `Dataplane` resource.
