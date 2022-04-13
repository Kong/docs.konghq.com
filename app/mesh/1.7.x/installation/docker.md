---
title: Kong Mesh with Docker
---

To install and run {{site.mesh_product_name}} on Docker:

1. [Download {{site.mesh_product_name}}](#1-download-kong-mesh)
1. [Run {{site.mesh_product_name}}](#2-run-kong-mesh)
1. [Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here
and continue your {{site.mesh_product_name}} journey.

The official Docker images are used by default in the
<a href="/mesh/{{page.kong_version}}/installation/kubernetes">Kubernetes</a>
distributions.

## Prerequisites
You have a license for {{site.mesh_product_name}}.

## 1. Download {{site.mesh_product_name}}

{{site.mesh_product_name}} provides the following Docker images for all of its
executables, hosted on Docker Hub:

* **kuma-cp**: at [`kong/kuma-cp:{{page.kong_latest.version}}`](https://hub.docker.com/r/kong/kuma-cp)
* **kuma-dp**: at [`kong/kuma-dp:{{page.kong_latest.version}}`](https://hub.docker.com/r/kong/kuma-dp)
* **kumactl**: at [`kong/kumactl:{{page.kong_latest.version}}`](https://hub.docker.com/r/kong/kumactl)
* **kuma-prometheus-sd**: at [`kong/kuma-prometheus-sd:{{page.kong_latest.version}}`](https://hub.docker.com/r/kong/kuma-prometheus-sd)

{:.note}
> **Note**: {{site.mesh_product_name}} also has UBI images, image names are prefixed with "ubi". For example `kong/ubi-kuma-cp` instead of `kong/kuma-cp`.

`docker pull` each image that you need. For example:

```sh
$ docker pull kong/kuma-cp:{{page.kong_latest.version}}
```

## 2. Run {{site.mesh_product_name}}

Run the control plane with:

```sh
$ docker run \
  -p 5681:5681 \
  -v /path/to/license.json:/license.json \
  -e "KMESH_LICENSE_PATH=/license.json" \
  kong/kuma-cp:{{page.kong_latest.version}} run
```

Where `/path/to/license.json` is the path to a valid {{site.mesh_product_name}}
license file on the host that will be mounted as `/license.json` into the
container.

This example will run {{site.mesh_product_name}} in standalone mode for a _flat_
deployment, but there are more advanced [deployment modes](https://kuma.io/docs/latest/introduction/deployments/)
like _multi-zone_.

This runs {{site.mesh_product_name}} with a [memory backend](https://kuma.io/docs/latest/explore/backends/), 
but you can use a persistent storage like PostgreSQL by updating the `conf/kuma-cp.conf` file.

## 3. Verify the Installation

Now that {{site.mesh_product_name}} (`kuma-cp`) is running, you can access the
control plane using either the GUI, the HTTP API, or the CLI:

{% navtabs %}
{% navtab GUI (Read-Only) %}
{{site.mesh_product_name}} ships with a **read-only** GUI that you can use to
retrieve {{site.mesh_product_name}} resources. By default, the GUI listens on
the API port `5681`.

To access {{site.mesh_product_name}}, navigate to `127.0.0.1:5681/gui` to see
the GUI.

{% endnavtab %}
{% navtab HTTP API (Read & Write) %}

{{site.mesh_product_name}} ships with a **read and write** HTTP API that you can
use to perform operations on {{site.mesh_product_name}} resources. By default,
the HTTP API listens on port `5681`.

To access {{site.mesh_product_name}}, navigate to `127.0.0.1:5681` to see
the HTTP API.

{% endnavtab %}
{% navtab kumactl (Read & Write) %}

You can use the `kumactl` CLI to perform **read and write** operations on
{{site.mesh_product_name}} resources. The `kumactl` binary is a client to
the {{site.mesh_product_name}} HTTP API. For example:

```sh
$ docker run \
  --net="host" \
  kong/kumactl:{{page.kong_latest.version}} kumactl get meshes

NAME          mTLS      METRICS      LOGGING   TRACING
default       off       off          off       off
```
Or, you can enable mTLS on the `default` Mesh with:

```sh
$ echo "type: Mesh
  name: default
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: builtin" | docker run -i --net="host" \
    kong/kumactl:{{page.kong_latest.version}} kumactl apply -f -
```

This runs `kumactl` from the Docker
container on the same network as the host, but most likely you want to download
a compatible version of {{site.mesh_product_name}} for the machine where you
will be executing the commands.

See the individual installation pages for your OS to download and extract
`kumactl` to your machine:
* [CentOS](/mesh/{{page.kong_version}}/installation/centos)
* [Red Hat](/mesh/{{page.kong_version}}/installation/redhat)
* [Debian](/mesh/{{page.kong_version}}/installation/debian)
* [Ubuntu](/mesh/{{page.kong_version}}/installation/ubuntu)
* [macOS](/mesh/{{page.kong_version}}/installation/macos)

{% endnavtab %}
{% endnavtabs %}

You will notice that {{site.mesh_product_name}} automatically creates a `Mesh`
entity with the name `default`.

## 4. Quickstart

The Kuma quickstart documentation
is fully compatible with {{site.mesh_product_name}}, except that you are
running {{site.mesh_product_name}} containers instead of Kuma containers.

To start using {{site.mesh_product_name}}, see the
[quickstart guide for Universal deployments](https://kuma.io/docs/latest/quickstart/universal/).
If you are entirely using Docker, you may also be interested in checking out the
[Kubernetes quickstart](https://kuma.io/docs/latest/quickstart/kubernetes/) as well.
