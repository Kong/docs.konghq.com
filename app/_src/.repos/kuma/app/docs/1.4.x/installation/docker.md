---
title: Docker
---

To install and run Kuma on Docker execute the following steps:

- [1. Download Kuma](#1-download-kuma)
- [2. Run Kuma](#2-run-kuma)
- [3. Use Kuma](#3-use-kuma)

{% tip %}
The official Docker images are used by default in the [Kubernetes](/docs/{{ page.version }}/installation/kubernetes/) and [OpenShift](/docs/{{ page.version }}/installation/openshift/) distributions.
{% endtip %}

### 1. Download Kuma

Kuma provides the following Docker images for all of its executables:

- **kuma-cp**: at `docker.io/kumahq/kuma-cp:1.4.1`
- **kuma-dp**: at `docker.io/kumahq/kuma-dp:1.4.1`
- **kumactl**: at `docker.io/kumahq/kumactl:1.4.1`
- **kuma-prometheus-sd**: at `docker.io/kumahq/kuma-prometheus-sd:1.4.1`

You can freely `docker pull` these images to start using Kuma, as we will demonstrate in the following steps.

### 2. Run Kuma

Finally we can run Kuma in either **standalone** or **multi-zone** mode:

{% tabs docker-run useUrlFragment=false %}
{% tab docker-run Standalone %}

Standalone mode is perfect when running Kuma in a single cluster across one environment:

```sh
docker run \
    -p 5681:5681 \
    docker.io/kumahq/kuma-cp:1.4.1 run
```

To learn more, read about the [deployment modes available](/docs/{{ page.version }}/documentation/deployments/).

{% endtab %}
{% tab docker-run Multi-Zone %}

Multi-zone mode is perfect when running one deployment of Kuma that spans across multiple Kubernetes clusters, clouds and VM environments under the same Kuma deployment.

This mode also supports hybrid Kubernetes + VMs deployments.

To learn more, read the [multi-zone installation instructions](/docs/{{ page.version }}/documentation/deployments/).

{% endtab %}
{% endtabs %}

{% tip %}
**Note**: By default this will run Kuma with a `memory` [backend](/docs/{{ page.version }}/documentation/backends), but you can use a persistent storage like PostgreSQL by updating the `conf/kuma-cp.conf` file.
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

### 3. Use Kuma

Kuma (`kuma-cp`) is now running! Now that Kuma has been installed you can access the control-plane via either the GUI, the HTTP API, or the CLI:

{% tabs docker-use useUrlFragment=false %}
{% tab docker-use GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma you can navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab docker-use HTTP API (Read & Write) %}

Kuma ships with a **read and write** HTTP API that you can use to perform operations on Kuma resources. By default the HTTP API listens on port `5681`.

To access Kuma you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab docker-use kumactl (Read & Write) %}

You can use the `kumactl` CLI to perform **read and write** operations on Kuma resources. The `kumactl` binary is a client to the Kuma HTTP API. For example:

```sh
docker run \
    --net="host" \
    docker.io/kumahq/kumactl: kumactl get meshes
# NAME          mTLS      METRICS      LOGGING   TRACING
# default       off       off          off       off
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
  docker.io/kumahq/kumactl: kumactl apply -f -
```

**Note**: we are running `kumactl` from the Docker container on the same network as the `host`, but most likely you want to download a compatible version of Kuma for the machine where you will be executing the commands.

You can run the following script to automatically detect the operating system and download Kuma:

<div class="language-sh">
<pre class="no-line-numbers"><code>curl -L https://kuma.io/installer.sh | VERSION={{ page.latest_version }} sh -</code></pre>
</div>

or you can download the distribution manually:

- [CentOS](https://download.konghq.com/mesh-alpine/kuma-1.4.1-centos-amd64.tar.gz)
- [RedHat](https://download.konghq.com/mesh-alpine/kuma-1.4.1-rhel-amd64.tar.gz)
- [Debian](https://download.konghq.com/mesh-alpine/kuma-1.4.1-debian-amd64.tar.gz)
- [Ubuntu](https://download.konghq.com/mesh-alpine/kuma-1.4.1-ubuntu-amd64.tar.gz)
- [macOS](https://download.konghq.com/mesh-alpine/kuma-1.4.1-darwin-amd64.tar.gz)

and extract the archive with:

```sh
tar xvzf kuma-*.tar.gz
```

You will then find the `kumactl` executable in the `kuma-1.4.1/bin` folder.

{% endtab %}
{% endtabs %}

You will notice that Kuma automatically creates a [`Mesh`](/docs/{{ page.version }}/policies/mesh) entity with name `default`.

### 4. Quickstart

Congratulations! You have successfully installed Kuma on Docker 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Universal](/docs/{{ page.version }}/quickstart/universal/) deployments. If you are using Docker you may also be interested in checking out the [Kubernetes quickstart](/docs/{{ page.version }}/quickstart/kubernetes/) as well.
