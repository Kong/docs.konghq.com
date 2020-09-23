---
title: Kong Mesh with Ubuntu
no_search: true
---

To install and run {{site.mesh_product_name}} on Ubuntu (**amd64**), execute
the following steps:


* [1. Download {{site.mesh_product_name}}](#1-download-kong-mesh)
* [2. Run Kong Mesh](#2-run-kong-mesh)
* [3. Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here and continue your {{site.mesh_product_name}} journey.

## Prerequisites
You have a license for {{site.mesh_product_name}}.

## 1. Download {{site.mesh_product_name}}

{% navtabs %}
{% navtab Script %}

Run the following script to automatically detect the operating system and
download {{site.mesh_product_name}}:

```sh
$ curl -L https://docs.konghq.com/mesh/installer.sh | sh -
```
{% endnavtab %}
{% navtab Manually %}

You can also [download](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-ubuntu-amd64.tar.gz)
 the distribution manually.

Then, extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.kong_latest.version}}*.tar.gz
```
{% endnavtab %}
{% endnavtabs %}

## 2. Run {{site.mesh_product_name}}
Once downloaded, you will find the contents of {{site.mesh_product_name}} in the `kong-mesh-{{page.kong_latest.version}}` folder. In this folder, you will find &mdash; among other files &mdash; the bin directory that stores all the executables for {{site.mesh_product_name}}.

Navigate to the `bin` folder:

```sh
$ cd kuma-0.7.1/bin
```

<div class="alert alert-ee blue">
<strong>Note:</strong> Before running the {{site.mesh_product_name}}
control plane process in the next step &mdash; which is served by the <code>kuma-cp</code>
executable &mdash; you need to have a valid {{site.mesh_product_name}} license
in place.
</div>

Run the control plane with:

```sh
$ KUMA_LICENSE_PATH=/path/to/file/license.json kuma-cp run
```

Where `/path/to/file/license.json` is the path to a valid
{{site.mesh_product_name}} license file on the file system.

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
<strong>Note:</strong> By default, this will run {{site.mesh_product_name}} with a memory
backend, but you can use a persistent storage like PostgreSQL by updating the
<code>conf/kuma-cp.conf</code> file.
</div>

## 3. Verify the Installation

Now that {{site.mesh_product_name}} has been installed, you can access the
control plane via either the GUI, the HTTP API, or the CLI:

{% navtabs %}
{% navtab GUI (Read-Only) %}
{{site.mesh_product_name}} ships with a read-only GUI that you can use to
retrieve {{site.mesh_product_name}} resources. By default, the GUI listens on
the API port `5681`.

To access {{site.mesh_product_name}}, navigate to `127.0.0.1:5681/gui` to see
the GUI.

{% endnavtab %}
{% navtab HTTP API (Read & Write) %}

{{site.mesh_product_name}} ships with a read and write HTTP API that you can
use to perform operations on {{site.mesh_product_name}} resources. By default,
the HTTP API listens on port `5681`.

To access {{site.mesh_product_name}}, navigate to `127.0.0.1:5681` to see
the HTTP API.

{% endnavtab %}
{% navtab kumactl (Read & Write) %}

You can use the `kumactl` CLI to perform read and write operations on
{{site.mesh_product_name}} resources. The `kumactl` binary is a client to
the {{site.mesh_product_name}} HTTP API. For example:

```sh
$ kumactl get meshes
NAME          mTLS      METRICS      LOGGING   TRACING
default       off       off          off       off
```
Or, you can enable mTLS on the `default` Mesh with:

```sh
echo "type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
  - name: ca-1
    type: builtin" | kumactl apply -f -
```
You can configure `kumactl` to point to any remote `kuma-cp` instance by running:

```sh
$ kumactl config control-planes add \
--name=XYZ \
--address=http://{address-to-mesh}:5681
```

{% endnavtab %}
{% endnavtabs %}

You will notice that {{site.mesh_product_name}} automatically creates a Mesh
entity with the name `default`.

## 4. Quickstart

Congratulations! You have successfully installed {{site.mesh_product_name}} on Ubuntu.

After installation, the Kuma quickstart documentation is fully compatible with
{{site.mesh_product_name}}, except that you are running {{site.mesh_product_name}}
binaries instead of the vanilla Kuma ones.

To start using {{site.mesh_product_name}}, see the [quickstart guide for Universal deployments](https://kuma.io/docs/latest/quickstart/universal/).
