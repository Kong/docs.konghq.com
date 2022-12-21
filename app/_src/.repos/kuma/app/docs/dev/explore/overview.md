---
title: Overview
---

This sections gives an overview of a {{site.mesh_product_name}} service mesh.
It also covers how to start integrating your services into your mesh.

A {{site.mesh_product_name}} mesh consists of two main components:

- The **data plane** consists of the proxies that run alongside your services.
  All of your mesh traffic flows through these proxies
  on its way to its destination.
  {{site.mesh_product_name}}'s uses [Envoy](https://www.envoyproxy.io/) for its data plane proxy.
- The **control plane** configures the data plane proxies for handling mesh traffic.
  However, the control plane runs independently of the data plane and does not
  interact with mesh traffic directly.
  {{site.mesh_product_name}} users create [policies](/docs/{{ page.version }}/policies/introduction)
  that the {{site.mesh_product_name}} control plane processes to generate configuration for the data plane proxies.

{% tip %}
**Multi-mesh**: one {{site.mesh_product_name}} control plane deployment can control multiple, isolated data planes using the [`Mesh`](/docs/{{ page.version }}/policies/mesh) resource. As compared to one control plane per data plane, this option lowers the complexity and operational cost of supporting multiple meshes.
{% endtip %}

This is a high level visualization of a {{site.mesh_product_name}} service mesh:

<center>
<img src="/assets/images/docs/0.4.0/diagram-06.jpg" alt="" style="padding-top: 20px; padding-bottom: 10px;"/>
</center>

Communication happens between the control and data plane
as well as between the services and their data plane proxies:

<center>
<img src="/assets/images/docs/0.4.0/diagram-07.jpg" alt="" style="padding-top: 20px; padding-bottom: 10px;"/>
</center>

{% tip %}
{{site.mesh_product_name}} implements the [Envoy **xDS** APIs](https://www.envoyproxy.io/docs/envoy/latest/api-docs/xds_protocol)
so that data plane proxies can retrieve their configuration from the control plane.
{% endtip %}

## Components

A minimal {{site.mesh_product_name}} deployment involves one or more instances of the control plane executable, `kuma-cp`.
For each service in your mesh, you'll have one or more instances of the data plane proxy executable, `kuma-dp`.

Users interact with the control plane via the command-line tool `kumactl`.

There are two modes that the {{site.mesh_product_name}} control plane can run in:

- `kubernetes`: users configure {{site.mesh_product_name}} via Kubernetes resources and
  {{site.mesh_product_name}} uses the Kubernetes API server as the data store.
- `universal`: users configure {{site.mesh_product_name}} via the {{site.mesh_product_name}} API server and {{site.mesh_product_name}} resources.
  PostgreSQL serves as the data store.
  This mode works for any infrastructure other than Kubernetes, though you can
  run a `universal` control plane on top of a Kubernetes cluster.

## Kubernetes mode

When running in **Kubernetes** mode, {{site.mesh_product_name}} stores all of its state and configuration on the underlying Kubernetes API Server.

<center>
<img src="/assets/images/docs/0.5.0/diagram-08.jpg" alt="" style="width: 500px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

The only step necessary to join your Kubernetes services to the mesh is enabling _sidecar injection_.
For any `Pods` configured with sidecar injection, {{site.mesh_product_name}} adds the `kuma-dp` sidecar container.
The following label on any `Namespace` or `Pod` controls this injection:

```
kuma.io/sidecar-injection: enabled
```

{% tip %}
**Injection**: learn more about sidecar injection in the section on [`Dataplanes`](/docs/{{ page.version }}/explore/dpp-on-kubernetes).

**Annotations**: see [the complete list of the Kubernetes annotations](/docs/{{ page.version }}/reference/kubernetes-annotations/).

**Policies with Kubernetes**: when using {{site.mesh_product_name}} in Kubernetes mode you create [policies](/docs/{{ page.version }}/policies/introduction) using `kubectl` and `kuma.io` CRDs.
{% endtip %}

### `Services` and `Pods`

#### `Pods` with a `Service`

For all Pods associated with a Kubernetes `Service` resource, {{site.mesh_product_name}} control plane automatically generates an annotation `kuma.io/service: <name>_<namespace>_svc_<port>` where `<name>`, `<namespace>` and `<port>` come from the `Service`. For example, the following resources generates `kuma.io/service: echo-server_kuma-test_svc_80`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: echo-server
  namespace: kuma-test
  annotations:
    80.service.kuma.io/protocol: http
spec:
  ports:
    - port: 80
      name: http
  selector:
    app: echo-server
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-server
  namespace: kuma-test
  labels:
    app: echo-server
spec:
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: echo-server
  template:
    metadata:
      labels:
        app: echo-server
    spec:
      containers:
        - name: echo-server
          image: nginx
          ports:
            - containerPort: 80
```

#### `Pods` without a `Service`

In some cases `Pods` don't belong to a corresponding `Service`.
This is typically because they don't expose any consumable services.
Kubernetes `Jobs` are a good example of this.

In this case, the {{site.mesh_product_name}} control plane generates a `kuma.io/service` tag with the format `<name>_<namespace>_svc`, where `<name>` and`<namespace>` come from the `Pod` resource itself.

The `Pods` created by the following example `Deployment` have the tag `kuma.io/service: example-client_kuma-example_svc`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-client
  labels:
    app: echo-client
spec:
  selector:
    matchLabels:
      app: echo-client
  template:
    metadata:
      labels:
        app: echo-client
    spec:
      containers:
        - name: alpine
          image: "alpine"
          imagePullPolicy: IfNotPresent
          command: ["sh", "-c", "tail -f /dev/null"]
```

## Universal mode

When running in **Universal** mode, {{site.mesh_product_name}} requires a PostgreSQL database to store its state. This replaces the Kubernetes API. With Universal, you use `kumactl` to interact directly with the {{site.mesh_product_name}} API server to manage policies.

<center>
<img src="/assets/images/docs/0.5.0/diagram-09.jpg" alt="" style="width: 500px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

Read [the docs about the PostgreSQL backend](/docs/{{ page.version }}/documentation/configuration#postgres) for more details.
