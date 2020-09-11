---
title: Kong Mesh with Docker
no_search: true
---

## Docker

To install and run {{site.mesh_product_name}} on Docker, execute the following
steps:

* [1. Download {{site.mesh_product_name}}](#1-download-kong-mesh)
* [2. Configure the license](#2-configure-the-license)
* [3. Follow Kuma instructions](#3-follow-kuma-instructions)

<div class="alert alert-ee blue">
The official Docker images are used by default in the
<a href="/mesh/{{page.kong_version}}/installation/kubernetes">Kubernetes</a>
distributions.  
</div>

### 1. Download {{site.mesh_product_name}}

{{site.mesh_product_name}} provides the following Docker images for all of its
executables:

* **kuma-cp**: at `kong-docker-kong-mesh-docker.bintray.io/kuma-cp:{{page.kong_latest.version}}`
* **kuma-dp**: at `kong-docker-kong-mesh-docker.bintray.io/kuma-dp:{{page.kong_latest.version}}`
* **kumactl**: at `kong-docker-kong-mesh-docker.bintray.io/kumactl:{{page.kong_latest.version}}`
* **kuma-prometheus-sd**: at `kong-docker-kong-mesh-docker.bintray.io/kuma-prometheus-sd:{{page.kong_latest.version}}`

`docker pull` each image that you need. For example:

```sh
$ docker pull kong-docker-kong-mesh-docker.bintray.io/kuma-cp:{{page.kong_latest.version}}
```

### 2. Configure The License

Before running the {{site.mesh_product_name}} control plane process - which is served by the `kuma-cp` container - we need to make sure that we have a valid {{site.mesh_product_name}} license in place.

This can be done by running the control plane with:

```sh
$ docker run \
    -p 5681:5681 \
    -v /path/to/license.json:/license.json \
    -e "KUMA_LICENSE_PATH=/license.json" \
    kong-docker-kuma-docker.bintray.io/kuma-cp:0.7.1 run
```

Where `/path/to/license.json` is the path to a valid {{site.mesh_product_name}} license file on the host that will be mounted as `/license.json` into the container.

### 3. Follow Kuma Instructions

After pulling the {{site.mesh_product_name}} images, the remaining installation
instructions for Kuma are fully compatible with {{site.mesh_product_name}},
except you will be using the {{site.mesh_product_name}} Docker images instead
of the vanilla Kuma ones.

To continue the installation, start from the second installation step in
[the official Kuma installation guide](https://kuma.io/docs/0.7.1/installation/docker/#_2-run-kuma).
