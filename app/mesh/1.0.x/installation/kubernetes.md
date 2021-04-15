---
title: Kong Mesh with Kubernetes
---

To install and run {{site.mesh_product_name}} on Kubernetes, execute the
following steps:

* [1. Download {{site.mesh_product_name}}](#1-download-kong-mesh)
* [2. Run {{site.mesh_product_name}}](#2-run-kong-mesh)
* [3. Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here
and continue your {{site.mesh_product_name}} journey.

## Prerequisites
You have a license for {{site.mesh_product_name}}.

## 1. Download {{site.mesh_product_name}}

To run {{site.mesh_product_name}} on Kubernetes, you need to download a
compatible version of {{site.mesh_product_name}} for the machine from which you
will be executing the commands.

{% navtabs %}
{% navtab Script %}

You can run the following script to automatically detect the operating system
and download {{site.mesh_product_name}}:

```sh
$ curl -L https://docs.konghq.com/mesh/installer.sh | sh -
```

{% endnavtab %}
{% navtab Manually %}

You can also download the distribution manually. Download a distribution for
the **client host** from where you will be executing the commands to access
Kubernetes:

* [CentOS](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-centos-amd64.tar.gz)
* [RedHat](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-rhel-amd64.tar.gz)
* [Debian](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-debian-amd64.tar.gz)
* [Ubuntu](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-ubuntu-amd64.tar.gz)
* [macOS](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-darwin-amd64.tar.gz)

Then, extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.kong_latest.version}}*.tar.gz
```

{% endnavtab %}
{% endnavtabs %}

## 2. Run {{site.mesh_product_name}}

<div class="alert alert-ee blue">
<strong>Note:</strong> Before running the {{site.mesh_product_name}}
control plane process in the next step &mdash; which is served by the
<code>kuma-cp</code> container &mdash; you need to have a valid
{{site.mesh_product_name}} license in place.
</div>

Navigate to the `bin` folder:

```sh
$ cd kong-mesh-{{page.kong_latest.version}}/bin
```

Then, run the control plane with:

```sh
$ kumactl install control-plane --license-path=/path/to/license.json | kubectl apply -f -
```

Where `/path/to/license.json` is the path to a valid {{site.mesh_product_name}}
license file on the file system.

This example will run {{site.mesh_product_name}} in standalone mode for a _flat_
deployment, but there are more advanced [deployment modes](https://kuma.io/docs/latest/documentation/deployments/)
like _multi-zone_.

We suggest adding the `kumactl` executable to your `PATH` so that it's always
available in every working directory. Alternatively, you can also create a link
in `/usr/local/bin/` by executing:

```sh
$ ln -s ./kumactl /usr/local/bin/kumactl
```

<div class="alert alert-ee blue">
<strong>Note:</strong> It may take a while for Kubernetes to start the
{{site.mesh_product_name}} resources. You can check the status by executing:
<pre class="highlight">
<code>$ kubectl get pod -n kuma-system</code></pre>
</div>

## 3. Verify the Installation

Now that {{site.mesh_product_name}} (`kuma-cp`) has been installed in the newly
created `kuma-system` namespace, you can access the control plane using either
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

Congratulations! You have successfully installed {{site.mesh_product_name}}.

After installation, the Kuma quickstart documentation is fully compatible with
{{site.mesh_product_name}}, except that you are running {{site.mesh_product_name}}
binaries instead of the vanilla Kuma ones.

To start using {{site.mesh_product_name}}, see the
[quickstart guide for Kubernetes deployments](https://kuma.io/docs/latest/quickstart/kubernetes/).
