---
title: Set up and explore the Kubernetes demo app
---

To start learning how Kuma works, you can download and run a simple demo application that consists of two services:

- `demo-app`: web application that lets you increment a numeric counter
- `redis`: data store for the counter

This guide also introduces some of the tools Kuma provides to help you control and monitor traffic, track resource status, and more.

The `demo-app` service listens on port 5000. When it starts, it expects to find a zone key in Redis that specifies the name of the datacenter (or cluster) where the Redis instance is running. This name is displayed in the browser.

The zone key is purely static and arbitrary. Different zone values for different Redis instances let you keep track of which Redis instance stores the counter if you manage routes across different zones, clusters, and clouds.

## Prerequisites

- [Kuma installed on your Kubernetes cluster](/docs/{{ page.version }}/installation/kubernetes/)
- [Demo app downloaded from GitHub](https://github.com/kumahq/kuma-counter-demo):

  ```sh
  git clone https://github.com/kumahq/kuma-counter-demo.git
  ```

## Set up and run

Two different YAML files are available:

- `demo.yaml` installs the basic resources
- `demo-v2.yaml` installs the frontend service with different colors. This lets you more clearly view routing across multiple versions, for example.

1.  Install resources in a `kuma-demo` namespace:

    ```sh
    kubectl apply -f demo.yaml
    ```

1.  Port forward the service to the namespace on port 5000:

    ```sh
    kubectl port-forward svc/demo-app -n kuma-demo 5000:5000
    ```

1.  In a browser, go to `127.0.0.1:5000` and increment the counter.

## Explore the mesh

The demo app includes the `kuma.io/sidecar-injection` label enabled on the `kuma-demo` namespace. This means that Kuma [already knows](/docs/{{ page.version }}/explore/dpp-on-kubernetes) that it needs to automatically inject a sidecar proxy to every Kubernetes deployment in the `default` [Mesh](/docs/{{ page.version }}/policies/mesh/) resource:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: kuma-demo
  namespace: kuma-demo
  labels:
    kuma.io/sidecar-injection: enabled
```

Run:

```sh
kubectl get namespace kuma-demo -oyaml
```

to see what the full namespace looks like:

```sh
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Namespace","metadata":{"labels":{"kuma.io/sidecar-injection":"enabled"},"name":"kuma-demo"}}
  labels:
    kuma.io/sidecar-injection: enabled
  creationTimestamp: "2021-08-13T09:17:48Z"
  labels:
    kubernetes.io/metadata.name: kuma-demo
  name: kuma-demo
  resourceVersion: "749"
  uid: 66b1279e-e49c-427d-af01-3adc91e505c1
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
```

You can view the sidecar proxies that are connected to the Kuma control plane:

{% tabs explore useUrlFragment=false %}
{% tab explore GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab explore HTTP API (Read-Only) %}

Kuma ships with a **read-only** HTTP API that you can use to retrieve Kuma resources.

By default the HTTP API listens on port `5681`. To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then you can navigate to [`127.0.0.1:5681/meshes/default/dataplanes`](http://127.0.0.1:5681/meshes/default/dataplanes) to see the connected dataplanes.

{% endtab %}
{% tab explore kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on Kuma resources. The `kumactl` binary is a client to the Kuma HTTP API, you will need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

and then run `kumactl`, for example:

```sh
kumactl get dataplanes
# MESH      NAME                                              TAGS
# default   kuma-demo-app-68758d8d5d-dddvg.kuma-demo          app=kuma-demo-demo-app env=prod pod-template-hash=68758d8d5d protocol=http service=demo-app_kuma-demo_svc_5000 version=v8
# default   redis-master-657c58c859-5wkb4.kuma-demo           app=redis pod-template-hash=657c58c859 protocol=tcp role=master service=redis_kuma-demo_svc_6379 tier=backend
```

You can configure `kumactl` to point to any zone `kuma-cp` instance by running:

```sh
kumactl config control-planes add --name=XYZ --address=http://{address-to-kuma}:5681
```

{% endtab %}
{% endtabs %}

## Enable Mutual TLS and Traffic Permissions

By default, the network is unsecure and not encrypted. We can change this with Kuma by enabling the [Mutual TLS](/docs/{{ page.version }}/policies/mutual-tls/) policy to provision a dynamic Certificate Authority (CA) on the `default` [Mesh](/docs/{{ page.version }}/policies/mesh/) resource that will automatically assign TLS certificates to our services (more specifically to the injected dataplane proxies running alongside the services).

We can enable Mutual TLS with a `builtin` CA backend by executing:

```sh
echo "apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: builtin" | kubectl apply -f -
```

Once Mutual TLS has been enabled, Kuma will **not allow** traffic to flow freely across our services unless we explicitly have a [Traffic Permission](/docs/{{ page.version }}/policies/traffic-permissions/) policy that describes what services can be consumed by other services.
By default, a very permissive traffic permission is created.

For the sake of this demo we will delete it:

```sh
kubectl delete trafficpermission allow-all-default
```

You can try to make requests to the demo application at [`127.0.0.1:5000/`](http://127.0.0.1:5000/) and you will notice that they will **not** work.

Now let's add back the default traffic permission:

```sh
echo "apiVersion: kuma.io/v1alpha1
kind: TrafficPermission
mesh: default
metadata:
  name: allow-all-default
spec:
  sources:
    - match:
        kuma.io/service: '*'
  destinations:
    - match:
        kuma.io/service: '*'" | kubectl apply -f -
```

By doing so every request we now make on our demo application at [`127.0.0.1:5000/`](http://127.0.0.1:5000/) is not only working again, but it is automatically encrypted and secure.

{% tip %}
As usual, you can visualize the Mutual TLS configuration and the Traffic Permission policies we have just applied via the GUI, the HTTP API or `kumactl`.
{% endtip %}

## Explore Traffic Metrics

One of the most important [policies](/policies) that Kuma provides out of the box is [Traffic Metrics](/docs/{{ page.version }}/policies/traffic-metrics/).

With Traffic Metrics we can leverage Prometheus and Grafana to provide powerful dashboards that visualize the overall traffic activity of our application and the status of the service mesh.

To enable traffic metrics we need to first install Prometheus and Grafana:

```sh
kumactl install metrics | kubectl apply -f -
```

This will provision a new `kuma-metrics` namespace with all the services required to run our metric collection and visualization. Please note that this operation can take a while as Kubernetes downloads all the required containers.

Once we have installed the required dependencies, we can now go ahead and enable metrics on our [Mesh]() object by executing:

```sh
echo "apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: builtin
  metrics:
    enabledBackend: prometheus-1
    backends:
    - name: prometheus-1
      type: prometheus" | kubectl apply -f -
```

This will enable the `prometheus` metrics backend on the `default` [Mesh](/docs/{{ page.version }}/policies/mesh/) and automatically collect metrics for all of our traffic.

Increment the counter to generate traffic. Then you can expose the Grafana dashboard:

```sh
kubectl port-forward svc/grafana -n kuma-metrics 3000:80
```

and access the dashboard at [127.0.0.1:3000](http://127.0.0.1:3000) with default credentials for both the username (`admin`) and the password (`admin`).

Kuma automatically installs three dashboard that are ready to use:

- `Kuma Mesh`: to visualize the status of the overall Mesh.
- `Kuma Dataplane`: to visualize metrics for a single individual dataplane.
- `Kuma Service to Service`: to visualize traffic metrics for our services.

You can now explore the dashboards and see the metrics being populated over time.

## Next steps

- Explore the [Policies](/policies) available to govern and orchestrate your service traffic.
- Read the [full documentation](/docs/{{ page.version }}/) to learn about all the capabilities of Kuma.
- Chat with us at the official [Kuma Slack](/community) for questions or feedback.
