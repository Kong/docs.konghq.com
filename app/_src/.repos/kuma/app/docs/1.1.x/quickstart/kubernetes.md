---
title: Quickstart in Kubernetes Mode
---

Congratulations! After [installing](/install) Kuma, you can get up and running with a few easy steps.

{% tip %}
Kuma can run in both **Kubernetes** (Containers) and **Universal** mode (for VMs and Bare Metal). You are now looking at the quickstart for Kubernetes mode, but you can also check out the [Universal one](/docs/{{ page.version }}/quickstart/universal).
{% endtip %}

In order to simulate a real-world scenario, we have built a simple demo application that resembles a marketplace. In this tutorial we will:

- [1. Run the Marketplace application](#_1-run-the-marketplace-application)
- [2. Enable Mutual TLS and Traffic Permissions](#_2-enable-mutual-tls-and-traffic-permissions)
- [3. Visualize Traffic Metrics](#_3-visualize-traffic-metrics)

You can also access the Kuma marketplace demo repository [on Github](https://github.com/kumahq/kuma-demo) to try more features and policies in addition to the ones described in this quickstart.

{% tip %}
**Community Chat**: If you need help, you can chat with the [Community](/community) where you can ask questions, contribute back to Kuma and send feedback.
{% endtip %}

### 1. Run the Marketplace application

First, Kuma must be [installed and running](/docs/{{ page.version }}/installation/kubernetes) in your Kubernetes cluster.

To install the marketplace demo application you can run:

```sh
kubectl apply -f https://bit.ly/demokuma
```

This will provision a new `kuma-demo` namespace with all the services required to run the application, in this case:

- `frontend`: the entry-point service that serves the web application.
- `backend`: the underlying backend component that powers the `frontend` service.
- `postgres`: the database that stores the marketplace items.
- `redis`: the backend storage for items reviews.

You can then access the application by executing:

```sh
kubectl port-forward svc/frontend -n kuma-demo 8080:8080
```

And navigate to [127.0.0.1:8080](http://127.0.0.1:8080).

#### See the connected dataplanes

Since the demo application already comes with the `kuma.io/sidecar-injection` annotation enabled on the `kuma-demo` namespace, Kuma [already knows](/docs/{{ page.version }}/documentation/dps-and-data-model/#kubernetes) that it needs to automatically inject a sidecar proxy to every Kubernetes deployment in the `default` [Mesh](/docs/{{ page.version }}/policies/mesh/) resource:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: kuma-demo
  namespace: kuma-demo
  annotations:
    kuma.io/sidecar-injection: enabled
```

You can visualize the sidecars proxies that have connected to Kuma by running:

{% tabs sidecars useUrlFragment=false %}
{% tab sidecars GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab sidecars HTTP API (Read-Only) %}

Kuma ships with a **read-only** HTTP API that you can use to retrieve Kuma resources.

By default the HTTP API listens on port `5681`. To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then you can navigate to [`127.0.0.1:5681/meshes/default/dataplanes`](http://127.0.0.1:5681/meshes/default/dataplanes) to see the connected dataplanes.

{% endtab %}
{% tab sidecars kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on Kuma resources. The `kumactl` binary is a client to the Kuma HTTP API, you will need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

and then run `kumactl`, for example:

```sh
kumactl get dataplanes
# MESH      NAME                                              TAGS
# default   postgres-master-78d9c9c8c9-n8zjk.kuma-demo        app=postgres pod-template-hash=78d9c9c8c9 protocol=tcp service=postgres_kuma-demo_svc_5432
# default   kuma-demo-backend-v0-6fdb79ddfd-dkrp4.kuma-demo   app=kuma-demo-backend env=prod pod-template-hash=6fdb79ddfd protocol=http service=backend_kuma-demo_svc_3001 version=v0
# default   kuma-demo-app-68758d8d5d-dddvg.kuma-demo          app=kuma-demo-frontend env=prod pod-template-hash=68758d8d5d protocol=http service=frontend_kuma-demo_svc_8080 version=v8
# default   redis-master-657c58c859-5wkb4.kuma-demo           app=redis pod-template-hash=657c58c859 protocol=tcp role=master service=redis_kuma-demo_svc_6379 tier=backend
```

You can configure `kumactl` to point to any remote `kuma-cp` instance by running:

```sh
kumactl config control-planes add --name=XYZ --address=http://{address-to-kuma}:5681
```

{% endtab %}
{% endtabs %}

### 2. Enable Mutual TLS and Traffic Permissions

By default the network is unsecure and not encrypted. We can change this with Kuma by enabling the [Mutual TLS](/docs/{{ page.version }}/policies/mutual-tls/) policy to provision a dynamic Certificate Authority (CA) on the `default` [Mesh](/docs/{{ page.version }}/policies/mesh/) resource that will automatically assign TLS certificates to our services (more specifically to the injected dataplane proxies running alongside the services).

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

Once Mutual TLS has been enabled, Kuma will **not allow** traffic to flow freely across our services unless we explicitly create a [Traffic Permission](/docs/{{ page.version }}/policies/traffic-permissions/) policy that describes what services can be consumed by other services. You can try to make requests to the demo application at [`127.0.0.1:8080/`](http://127.0.0.1:8080/) and you will notice that they will **not** work.

{% tip %}
In a live environment we suggest to setup the Traffic Permission policies prior to enabling Mutual TLS in order to avoid unexpected interruptions of the service-to-service traffic.
{% endtip %}

We can setup a very permissive policy that allows all traffic to flow in our application in an encrypted way with the following command:

```sh
echo "apiVersion: kuma.io/v1alpha1
kind: TrafficPermission
mesh: default
metadata:
  namespace: default
  name: all-traffic-allowed
spec:
  sources:
    - match:
        kuma.io/service: '*'
  destinations:
    - match:
        kuma.io/service: '*'" | kubectl apply -f -
```

By doing so every request we now make on our demo application at [`127.0.0.1:8080/`](http://127.0.0.1:8080/) is not only working again, but it is automatically encrypted and secure.

{% tip %}
As usual, you can visualize the Mutual TLS configuration and the Traffic Permission policies we have just applied via the GUI, the HTTP API or `kumactl`.
{% endtip %}

### 3. Visualize Traffic Metrics

Among the [many policies](/policies) that Kuma provides out of the box, one of the most important ones is [Traffic Metrics](/docs/{{ page.version }}/policies/traffic-metrics/).

With Traffic Metrics we can leverage Prometheus and Grafana to visualize powerful dashboards that show the overall traffic activity of our application and the status of the Service Mesh.

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

Now let's go ahead and generate some traffic - to populate our charts - by using the demo application!

{% tip %}
You can also generate some artificial traffic with the following command to save some clicks:

```sh
while [ true ]; do curl http://127.0.0.1:8080/items?q=; curl http://127.0.0.1:8080/items/1/reviews; done
```

{% endtip %}

To visualize the traffic we can now expose the Grafana dashboard with:

```sh
kubectl port-forward svc/grafana -n kuma-metrics 3000:80
```

and then access the Grafana dashboard at [127.0.0.1:3000](http://127.0.0.1:3000) with default credentials for both the username (`admin`) and the password (`admin`).

Kuma automatically installs three dashboard that are ready to use:

- `Kuma Mesh`: to visualize the status of the overall Mesh.
- `Kuma Dataplane`: to visualize metrics for a single individual dataplane.
- `Kuma Service to Service`: to visualize traffic metrics for our services.

You can now explore the dashboards and see the metrics being populated over time.

# Next steps

{% tip %}
**Protip**: Use `#kumamesh` on Twitter to chat about Kuma.
{% endtip %}

Congratulations! You have completed the quickstart for Kubernetes, but there is so much more that you can do with Kuma:

- Explore the [Policies](/policies) available to govern and orchestrate your service traffic.
- Read the [full documentation](/docs/{{ page.version}}/) to learn about all the capabilities of Kuma.
- Chat with us at the official [Kuma Slack](/community) for questions or feedback.
