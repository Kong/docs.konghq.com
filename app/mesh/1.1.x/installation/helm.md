---
title: Kong Mesh with Helm
---

To install and run {{site.mesh_product_name}} on Kubernetes using Helm, execute
the following steps:

* [1. Add the {{site.mesh_product_name}} Helm Repository](#1-add-the-kong-mesh-helm-repository)
* [2. Run {{site.mesh_product_name}}](#2-run-kong-mesh)
* [3. Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here and continue your {{site.mesh_product_name}} journey.

## Prerequisites
You have a license for {{site.mesh_product_name}}.

## 1. Add the {{site.mesh_product_name}} Helm Repository

To start using {{site.mesh_product_name}} with Helm charts, first add the
{{site.mesh_product_name}} charts repository to your local Helm deployment:

```sh
$ helm repo add kong-mesh https://kong.github.io/kong-mesh-charts
```

Once the repo is added, any following updates can be fetched with
`helm repo update`.

## 2. Run {{site.mesh_product_name}}

Install and run {{site.mesh_product_name}} using the following commands.
You can use any Kubernetes namespace to install Kuma, but as a default, we
suggest `kong-mesh-system`.

1. Create the `kong-mesh-system` namespace:

    ```sh
    $ kubectl create namespace kong-mesh-system
    ```

2. Upload the license secret to the cluster:

    ```sh
    $ kubectl create secret generic kong-mesh-license -n kong-mesh-system --from-file=/path/to/license.json
    ```

    Where `/path/to/license.json` is the path to a valid {{site.mesh_product_name}}
    license file on the file system.

    <div class="alert alert-ee blue">
    <strong>Note:</strong>The name of the file should be <code>license.json</code>, unless otherwise specified in <code>values.yaml</code>.
    </div>

3. Deploy the {{site.mesh_product_name}} Helm chart:

    ```sh
    $ helm repo update
    $ helm upgrade -i -n kong-mesh-system kong-mesh kong-mesh/kong-mesh
    ```

    This example will run {{site.mesh_product_name}} in standalone mode for a _flat_
    deployment, but there are more advanced [deployment modes](https://kuma.io/docs/latest/introduction/deployments/)
    like _multi-zone_.

## 3. Verify the Installation

Now that {{site.mesh_product_name}} (`kuma-cp`) has been installed in the newly
created `kong-mesh-system` namespace, you can access the control plane using either
the GUI, `kubectl`, the HTTP API, or the CLI:

{% navtabs %}
{% navtab GUI (Read-Only) %}
{{site.mesh_product_name}} ships with a **read-only** GUI that you can use to
retrieve {{site.mesh_product_name}} resources. By default, the GUI listens on
the API port `5681`.

To access {{site.mesh_product_name}}, port-forward the API service with:

```sh
$ kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

Now you can navigate to `127.0.0.1:5681/gui` to see the GUI.

{% endnavtab %}
{% navtab kubectl (Read & Write) %}
You can use {{site.mesh_product_name}} with `kubectl` to perform
**read and write** operations on {{site.mesh_product_name}} resources. For
example:

```sh
$ kubectl get meshes

NAME          AGE
default       1m
```

Or, you can enable mTLS on the `default` Mesh with:

```sh
$ echo "apiVersion: kuma.io/v1alpha1
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

{% endnavtab %}
{% navtab HTTP API (Read-Only) %}

{{site.mesh_product_name}} ships with a **read-only** HTTP API that you use
to retrieve {{site.mesh_product_name}} resources. By default,
the HTTP API listens on port `5681`.

To access {{site.mesh_product_name}}, port-forward the API service with:

```sh
$ kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

Now you can navigate to `127.0.0.1:5681` to see the HTTP API.

{% endnavtab %}
{% navtab kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on
{{site.mesh_product_name}} resources. The `kumactl` binary is a client to
the {{site.mesh_product_name}} HTTP API. To use it, first port-forward the API
service with:

```sh
$ kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

Then run `kumactl`. For example:

```sh
$ kumactl get meshes

NAME          mTLS      METRICS      LOGGING   TRACING
default       off       off          off       off
```

You can configure `kumactl` to point to any remote `kuma-cp` instance by running:

```
$ kumactl config control-planes add --name=XYZ --address=http://{address-to-kong-mesh}:5681
```

{% endnavtab %}
{% endnavtabs %}

You will notice that {{site.mesh_product_name}} automatically creates a `Mesh`
entity with the name `default`.

## 4. Quickstart

Congratulations! You have successfully installed {{site.mesh_product_name}} on
Kubernetes.

After installation, the Kuma quickstart documentation is fully compatible with
{{site.mesh_product_name}}, except that you are running {{site.mesh_product_name}}
binaries instead of the vanilla Kuma ones.

To start using {{site.mesh_product_name}}, see the
[quickstart guide for Kubernetes deployments](https://kuma.io/docs/latest/quickstart/kubernetes/).
