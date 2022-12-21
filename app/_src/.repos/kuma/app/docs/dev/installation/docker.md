---
title: Docker
---

To install and run {{site.mesh_product_name}} on Docker execute the following steps:

- [1. Download {{site.mesh_product_name}}](#1-download-kuma)
- [2. Run {{site.mesh_product_name}}](#2-run-kuma)
- [3. Use {{site.mesh_product_name}}](#3-use-kuma)

{% tip %}
The official Docker images are used by default in the [Kubernetes](/docs/{{ page.version }}/installation/kubernetes/) and [OpenShift](/docs/{{ page.version }}/installation/openshift/) distributions.
{% endtip %}

### 1. Download {{site.mesh_product_name}}

{{site.mesh_product_name}} provides the following Docker images for all of its executables:

- **kuma-cp**: at `docker.io/kumahq/kuma-cp:{{ page.latest_version }}`
- **kuma-dp**: at `docker.io/kumahq/kuma-dp:{{ page.latest_version }}`
- **kumactl**: at `docker.io/kumahq/kumactl:{{ page.latest_version }}`

You can freely `docker pull` these images to start using {{site.mesh_product_name}}, as we will demonstrate in the following steps.

### 2. Run {{site.mesh_product_name}}

We can run {{site.mesh_product_name}}:

`docker run -p 5681:5681 docker.io/kumahq/kuma-cp:{{ page.latest_version }} run`

This example will run {{site.mesh_product_name}} in `standalone` mode for a "flat" deployment, but there are more advanced [deployment modes](/docs/{{ page.version }}/introduction/deployments) like "multi-zone".

{% tip %}
**Note**: By default this will run {{site.mesh_product_name}} with a `memory` [store](/docs/{{ page.version }}/documentation/configuration#store), but you can use a persistent storage like PostgreSQL by updating the `conf/kuma-cp.conf` file.
{% endtip %}

#### 2.1 Authentication (optional)

Running administrative tasks (like generating a dataplane token) requires [authentication by token](/docs/{{ page.version }}/security/api-server-auth/#admin-user-token) or a connection via localhost.

##### 2.1.1 Localhost

For `kuma-cp` to recognize requests issued to docker published port it needs to run the container in the host network.
To do this, add `--network="host"` parameter to the `docker run` command from point 2.

##### 2.1.2 Authenticating via token

You can also configure `kumactl` to access `kuma-dp` from the container.
Get the `kuma-cp` container id:

```sh
docker ps # copy kuma-cp container id

export KUMA_CP_CONTAINER_ID='...'
```

Configure `kumactl`:

```sh
TOKEN=$(bash -c "docker exec -it $KUMA_CP_CONTAINER_ID wget -q -O - http://localhost:5681/global-secrets/admin-user-token" | jq -r .data | base64 -d)

kumactl config control-planes add \
 --name my-control-plane \
 --address http://localhost:5681 \
 --auth-type=tokens \
 --auth-conf token=$TOKEN \
 --skip-verify
```

### 3. Use {{site.mesh_product_name}}

{{site.mesh_product_name}} (`kuma-cp`) is now running! Now that {{site.mesh_product_name}} has been installed you can access the control-plane via either the GUI, the HTTP API, or the CLI:

{% tabs docker-use useUrlFragment=false %}
{% tab docker-use GUI (Read-Only) %}

{{site.mesh_product_name}} ships with a **read-only** GUI that you can use to retrieve {{site.mesh_product_name}} resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access {{site.mesh_product_name}} you can navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab docker-use HTTP API (Read & Write) %}

{{site.mesh_product_name}} ships with a **read and write** HTTP API that you can use to perform operations on {{site.mesh_product_name}} resources. By default the HTTP API listens on port `5681`.

To access {{site.mesh_product_name}} you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab docker-use kumactl (Read & Write) %}

You can use the `kumactl` CLI to perform **read and write** operations on {{site.mesh_product_name}} resources. The `kumactl` binary is a client to the {{site.mesh_product_name}} HTTP API. For example:

```sh
docker run --net="host" kumahq/kumactl:<version> kumactl get meshes
NAME          mTLS      METRICS      LOGGING   TRACING
default       off       off          off       off
```

or you can enable mTLS on the `default` Mesh with:

```sh
echo "type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
  - name: ca-1
    type: builtin" | docker run -i --net="host" \
  docker.io/kumahq/kumactl:<version> kumactl apply -f -
```

**Note**: we are running `kumactl` from the Docker container on the same network as the `host`, but most likely you want to download a compatible version of {{site.mesh_product_name}} for the machine where you will be executing the commands.

You can run the following script to automatically detect the operating system and download {{site.mesh_product_name}}:

```sh
curl -L https://kuma.io/installer.sh | sh -
```

or you can download the distribution manually:

- <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-centos-amd64.tar.gz">CentOS</a>
- <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-rhel-amd64.tar.gz">RedHat</a>
- <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-debian-amd64.tar.gz">Debian</a>
- <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-ubuntu-amd64.tar.gz">Ubuntu</a>
- <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-darwin-amd64.tar.gz">macOS</a> or run `brew install kumactl`

and extract the archive with:

```sh
tar xvzf kuma-*.tar.gz
```

You will then find the `kumactl` executable in the `kuma-{{ page.latest_version }}/bin` folder.

{% endtab %}
{% endtabs %}

You will notice that {{site.mesh_product_name}} automatically creates a [`Mesh`](/docs/{{ page.version }}/policies/mesh) entity with name `default`.

### 4. Quickstart

Congratulations! You have successfully installed {{site.mesh_product_name}} on Docker 🚀.

In order to start using {{site.mesh_product_name}}, it's time to check out the [quickstart guide for Universal](/docs/{{ page.version }}/quickstart/universal/) deployments. If you are using Docker you may also be interested in checking out the [Kubernetes quickstart](/docs/{{ page.version }}/quickstart/kubernetes/) as well.
