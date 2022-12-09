---
title: Helm
---

To install and run Kuma on Kubernetes with Helm charts execute the following steps:

- [1. Add the Kuma charts repository](#_1-add-the-kuma-charts-repository)
- [2. Run Kuma](#2-run-kuma)
- [3. Use Kuma](#3-use-kuma)

Finally you can follow the [Quickstart](#4-quickstart) to take it from here and continue your Kuma journey.

{% tip %}
Kuma also provides an alternative [Kubernetes distribution](/docs/{{ page.version }}/installation/kubernetes/) that we can use instead of Helm charts.
{% endtip %}

### 1. Add the Kuma charts repository

To start using Kuma with Helm charts, we first need to add the [Kuma charts repository](https://kumahq.github.io/charts) to our local Helm deployment:

```sh
helm repo add kuma https://kumahq.github.io/charts
```

Once the repo is added, all following updates can be fetched with `helm repo update`.

### Run Kuma

At this point we can install and run Kuma using the following commands. We could use any Kubernetes namespace to install Kuma, by default we suggest using `kuma-system`:

```sh
helm install --version 0.7.1 --create-namespace --namespace kuma-system kuma kuma/kuma
```

This example will run Kuma in `standalone` mode for a "flat" deployment, but there are more advanced [deployment modes](/docs/{{ page.version }}/documentation/deployments) like "multi-zone".

### 3. Use Kuma

Kuma (`kuma-cp`) will be installed in the newly created `kuma-system` namespace! Now that Kuma has been installed, you can access the control-plane via either the GUI, `kubectl`, the HTTP API, or the CLI:

{% tabs helm-use useUrlFragment=false %}
{% tab helm-use GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab helm-use kubectl (Read & Write) %}

You can use Kuma with `kubectl` to perform **read and write** operations on Kuma resources. For example:

```sh
kubectl get meshes
# NAME          AGE
# default       1m
```

or you can enable mTLS on the `default` Mesh with:

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

{% endtab %}
{% tab helm-use HTTP API (Read-Only) %}

Kuma ships with a **read-only** HTTP API that you can use to retrieve Kuma resources.

By default the HTTP API listens on port `5681`. To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab helm-use kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on Kuma resources. The `kumactl` binary is a client to the Kuma HTTP API, you will need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

and then run `kumactl`, for example:

```sh
kumactl get meshes
# NAME          mTLS      METRICS      LOGGING   TRACING
# default       off       off          off       off
```

You can configure `kumactl` to point to any zone `kuma-cp` instance by running:

```sh
kumactl config control-planes add --name=XYZ --address=http://{address-to-kuma}:5681
```

{% endtab %}
{% endtabs %}

You will notice that Kuma automatically creates a [`Mesh`](/docs/{{ page.version }}/policies/mesh) entity with name `default`.

### 4. Quickstart

Congratulations! You have successfully installed Kuma on Kubernetes 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Kubernetes](/docs/{{ page.version }}/quickstart/kubernetes/) deployments.
